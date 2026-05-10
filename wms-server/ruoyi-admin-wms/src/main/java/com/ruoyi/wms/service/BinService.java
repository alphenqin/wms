package com.ruoyi.wms.service;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.lang.Assert;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.constant.HttpStatus;
import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.BinBo;
import com.ruoyi.wms.domain.entity.Area;
import com.ruoyi.wms.domain.entity.Bin;
import com.ruoyi.wms.domain.entity.Valve;
import com.ruoyi.wms.domain.entity.Warehouse;
import com.ruoyi.wms.domain.vo.BinVo;
import com.ruoyi.wms.mapper.AreaMapper;
import com.ruoyi.wms.mapper.BinMapper;
import com.ruoyi.wms.mapper.ValveMapper;
import com.ruoyi.wms.mapper.WarehouseMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 货位Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class BinService extends ServiceImpl<BinMapper, Bin> {

    public static final int STORAGE_STATUS_EMPTY_BIN = 0;
    public static final int STORAGE_STATUS_EMPTY_PALLET = 1;
    public static final int STORAGE_STATUS_FULL_PALLET = 2;

    private final BinMapper binMapper;
    private final WarehouseMapper warehouseMapper;
    private final AreaMapper areaMapper;
    private final ValveMapper valveMapper;

    /**
     * 查询货位
     */
    public BinVo queryById(Long id) {
        BinVo vo = binMapper.selectVoById(id);
        fillNames(vo);
        return vo;
    }

    /**
     * 根据货位编号查询
     */
    public BinVo queryByBinCode(String binCode) {
        LambdaQueryWrapper<Bin> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Bin::getBinCode, binCode);
        Bin bin = binMapper.selectOne(wrapper);
        BinVo vo = bin != null ? MapstructUtils.convert(bin, BinVo.class) : null;
        fillNames(vo);
        return vo;
    }

    /**
     * 查询货位列表
     */
    public TableDataInfo<BinVo> queryPageList(BinBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<Bin> lqw = buildQueryWrapper(bo);
        Page<BinVo> result = binMapper.selectVoPage(pageQuery.build(), lqw);
        fillNames(result.getRecords());
        return TableDataInfo.build(result);
    }

    /**
     * 查询货位列表
     */
    public List<BinVo> queryList(BinBo bo) {
        LambdaQueryWrapper<Bin> lqw = buildQueryWrapper(bo);
        List<BinVo> list = binMapper.selectVoList(lqw);
        fillNames(list);
        return list;
    }

    /**
     * 查询空闲货位列表
     */
    public List<BinVo> queryAvailableBins(Long warehouseId, Long areaId) {
        LambdaQueryWrapper<Bin> lqw = Wrappers.lambdaQuery();
        lqw.eq(warehouseId != null, Bin::getWarehouseId, warehouseId);
        lqw.eq(areaId != null, Bin::getAreaId, areaId);
        lqw.eq(Bin::getStatus, 0); // 0:空闲
        lqw.eq(Bin::getStorageStatus, STORAGE_STATUS_EMPTY_BIN);
        lqw.orderByAsc(Bin::getOrderNum);
        List<BinVo> list = binMapper.selectVoList(lqw);
        fillNames(list);
        return list;
    }

    /**
     * 获取最小可用库位（按库位号升序）
     */
    public BinVo queryFirstAvailableBin(Long warehouseId, Long areaId) {
        LambdaQueryWrapper<Bin> lqw = Wrappers.lambdaQuery();
        lqw.eq(warehouseId != null, Bin::getWarehouseId, warehouseId);
        lqw.eq(areaId != null, Bin::getAreaId, areaId);
        lqw.eq(Bin::getStatus, 0); // 0:空闲
        lqw.eq(Bin::getStorageStatus, STORAGE_STATUS_EMPTY_BIN);
        lqw.orderByAsc(Bin::getBinCode);
        lqw.last("limit 1");
        Bin bin = binMapper.selectOne(lqw);
        BinVo vo = bin != null ? MapstructUtils.convert(bin, BinVo.class) : null;
        fillNames(vo);
        return vo;
    }

    private void fillNames(BinVo vo) {
        if (vo == null) {
            return;
        }
        if (vo.getWarehouseId() != null && vo.getWarehouseName() == null) {
            Warehouse warehouse = warehouseMapper.selectById(vo.getWarehouseId());
            if (warehouse != null) {
                vo.setWarehouseName(warehouse.getWarehouseName());
            }
        }
        if (vo.getAreaId() != null && vo.getAreaName() == null) {
            Area area = areaMapper.selectById(vo.getAreaId());
            if (area != null) {
                vo.setAreaName(area.getAreaName());
            }
        }
    }

    private void fillNames(List<BinVo> list) {
        if (list == null || list.isEmpty()) {
            return;
        }
        Set<Long> warehouseIds = list.stream()
            .map(BinVo::getWarehouseId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
        Set<Long> areaIds = list.stream()
            .map(BinVo::getAreaId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
        Map<Long, String> warehouseNameMap = warehouseIds.isEmpty()
            ? Map.of()
            : warehouseMapper.selectList(Wrappers.<Warehouse>lambdaQuery().in(Warehouse::getId, warehouseIds))
                .stream()
                .collect(Collectors.toMap(Warehouse::getId, Warehouse::getWarehouseName, (a, b) -> a));
        Map<Long, String> areaNameMap = areaIds.isEmpty()
            ? Map.of()
            : areaMapper.selectList(Wrappers.<Area>lambdaQuery().in(Area::getId, areaIds))
                .stream()
                .collect(Collectors.toMap(Area::getId, Area::getAreaName, (a, b) -> a));
        for (BinVo vo : list) {
            if (vo.getWarehouseId() != null && vo.getWarehouseName() == null) {
                vo.setWarehouseName(warehouseNameMap.get(vo.getWarehouseId()));
            }
            if (vo.getAreaId() != null && vo.getAreaName() == null) {
                vo.setAreaName(areaNameMap.get(vo.getAreaId()));
            }
        }
    }

    private LambdaQueryWrapper<Bin> buildQueryWrapper(BinBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<Bin> lqw = Wrappers.lambdaQuery();
        lqw.like(StrUtil.isNotBlank(bo.getBinCode()), Bin::getBinCode, bo.getBinCode());
        lqw.like(StrUtil.isNotBlank(bo.getBinName()), Bin::getBinName, bo.getBinName());
        lqw.eq(bo.getWarehouseId() != null, Bin::getWarehouseId, bo.getWarehouseId());
        lqw.eq(bo.getAreaId() != null, Bin::getAreaId, bo.getAreaId());
        lqw.eq(bo.getBinType() != null, Bin::getBinType, bo.getBinType());
        lqw.eq(bo.getTemperatureZone() != null, Bin::getTemperatureZone, bo.getTemperatureZone());
        lqw.eq(bo.getStatus() != null, Bin::getStatus, bo.getStatus());
        lqw.eq(bo.getStorageStatus() != null, Bin::getStorageStatus, bo.getStorageStatus());
        lqw.like(StrUtil.isNotBlank(bo.getBoundFactoryNo()), Bin::getBoundFactoryNo, bo.getBoundFactoryNo());
        lqw.orderByAsc(Bin::getOrderNum);
        return lqw;
    }

    /**
     * 新增货位
     */
    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(BinBo bo) {
        validateBinCode(bo);
        Bin add = MapstructUtils.convert(bo, Bin.class);
        add.setOrderNum(this.getNextOrderNum(bo.getWarehouseId()));
        if (add.getStatus() == null) {
            add.setStatus(0); // 默认空闲
        }
        if (add.getUsedCapacity() == null) {
            add.setUsedCapacity(java.math.BigDecimal.ZERO);
        }
        if (add.getStorageStatus() == null) {
            add.setStorageStatus(STORAGE_STATUS_EMPTY_BIN);
        }
        normalizeStorageFields(add);
        binMapper.insert(add);
        syncValveStorageForBin(null, add);
    }

    private Long getNextOrderNum(Long warehouseId) {
        LambdaQueryWrapper<Bin> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(warehouseId != null, Bin::getWarehouseId, warehouseId);
        wrapper.orderByDesc(Bin::getOrderNum);
        wrapper.last("limit 1");
        Bin bin = binMapper.selectOne(wrapper);
        return bin == null ? 0L : bin.getOrderNum() + 1;
    }

    /**
     * 修改货位
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(BinBo bo) {
        validateBinCode(bo);
        Bin current = bo.getId() == null ? null : binMapper.selectById(bo.getId());
        Bin update = MapstructUtils.convert(bo, Bin.class);
        normalizeStorageFields(update);
        binMapper.updateById(update);
        binMapper.update(null, Wrappers.<Bin>lambdaUpdate()
            .eq(Bin::getId, update.getId())
            .set(Bin::getStatus, update.getStatus())
            .set(Bin::getStorageStatus, update.getStorageStatus())
            .set(Bin::getBoundFactoryNo, update.getBoundFactoryNo())
            .set(Bin::getUsedCapacity, update.getUsedCapacity()));
        syncValveStorageForBin(current, update);
    }

    private void validateBinCode(BinBo bin) {
        LambdaQueryWrapper<Bin> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(Bin::getBinCode, bin.getBinCode());
        List<Bin> binList = binMapper.selectList(queryWrapper);
        boolean validateCodeResult = binList.stream().anyMatch(
            it -> Objects.equals(it.getBinCode(), bin.getBinCode()) && !Objects.equals(it.getId(), bin.getId()));
        Assert.isFalse(validateCodeResult, "货位编号重复");
    }

    /**
     * 删除货位
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        validIdBeforeDelete(id);
        binMapper.deleteById(id);
    }

    private void validIdBeforeDelete(Long id) {
        Bin bin = binMapper.selectById(id);
        if (bin != null && bin.getStorageStatus() != null
            && !Objects.equals(bin.getStorageStatus(), STORAGE_STATUS_EMPTY_BIN)) {
            throw new ServiceException("删除失败", HttpStatus.CONFLICT, "该货位已被占用，无法删除！");
        }
    }

    /**
     * 批量删除货位
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        for (Long id : ids) {
            validIdBeforeDelete(id);
        }
        binMapper.deleteBatchIds(ids);
    }

    /**
     * 更新货位状态
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(Long id, Integer status) {
        Bin bin = binMapper.selectById(id);
        if (bin == null) {
            throw new ServiceException("货位不存在");
        }
        bin.setStatus(status);
        binMapper.updateById(bin);
    }

    /**
     * 更新货位占用容量
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateUsedCapacity(Long id, java.math.BigDecimal usedCapacity) {
        Bin bin = binMapper.selectById(id);
        if (bin == null) {
            throw new ServiceException("货位不存在");
        }
        bin.setUsedCapacity(usedCapacity);
        // 如果容量已满，更新状态为占用
        if (bin.getCapacity() != null && usedCapacity.compareTo(bin.getCapacity()) >= 0) {
            bin.setStatus(1); // 占用
        } else if (usedCapacity.compareTo(java.math.BigDecimal.ZERO) == 0) {
            bin.setStatus(0); // 空闲
        }
        binMapper.updateById(bin);
    }

    /**
     * 标记为空库位。
     */
    @Transactional(rollbackFor = Exception.class)
    public void markEmptyBin(String binCode) {
        updateStorageStatus(binCode, STORAGE_STATUS_EMPTY_BIN, null);
    }

    /**
     * 如果库位当前绑定的是指定出厂编号，则标记为空库位。
     */
    @Transactional(rollbackFor = Exception.class)
    public void markEmptyBinIfBoundTo(String binCode, String valveNo) {
        String normalizedBinCode = StrUtil.trimToNull(binCode);
        String normalizedValveNo = StrUtil.trimToNull(valveNo);
        if (normalizedBinCode == null || normalizedValveNo == null) {
            return;
        }
        Bin bin = binMapper.selectOne(Wrappers.<Bin>lambdaQuery()
            .eq(Bin::getBinCode, normalizedBinCode));
        if (bin != null && Objects.equals(StrUtil.trimToNull(bin.getBoundFactoryNo()), normalizedValveNo)) {
            updateStorageStatus(normalizedBinCode, STORAGE_STATUS_EMPTY_BIN, null);
        }
    }

    /**
     * 标记为空托盘库位。
     */
    @Transactional(rollbackFor = Exception.class)
    public void markEmptyPallet(String binCode) {
        updateStorageStatus(binCode, STORAGE_STATUS_EMPTY_PALLET, null);
    }

    /**
     * 标记为满托盘库位，并绑定出厂编号。
     */
    @Transactional(rollbackFor = Exception.class)
    public void markFullPallet(String binCode, String valveNo) {
        updateStorageStatus(binCode, STORAGE_STATUS_FULL_PALLET, valveNo);
    }

    private void updateStorageStatus(String binCode, Integer storageStatus, String boundFactoryNo) {
        String normalizedBinCode = StrUtil.trimToNull(binCode);
        if (normalizedBinCode == null || storageStatus == null) {
            return;
        }
        String normalizedBoundFactoryNo = normalizeBoundFactoryNo(storageStatus, boundFactoryNo);
        BigDecimal usedCapacity = Objects.equals(storageStatus, STORAGE_STATUS_EMPTY_BIN)
            ? BigDecimal.ZERO : BigDecimal.ONE;
        Integer status = Objects.equals(storageStatus, STORAGE_STATUS_EMPTY_BIN) ? 0 : 1;
        binMapper.update(null, Wrappers.<Bin>lambdaUpdate()
            .eq(Bin::getBinCode, normalizedBinCode)
            .set(Bin::getStatus, status)
            .set(Bin::getStorageStatus, storageStatus)
            .set(Bin::getBoundFactoryNo, normalizedBoundFactoryNo)
            .set(Bin::getUsedCapacity, usedCapacity));
    }

    private void syncValveStorageForBin(Bin oldBin, Bin current) {
        if (current == null) {
            return;
        }
        String oldBinCode = oldBin == null ? null : StrUtil.trimToNull(oldBin.getBinCode());
        String oldBoundFactoryNo = oldBin == null ? null : StrUtil.trimToNull(oldBin.getBoundFactoryNo());
        String currentBinCode = StrUtil.trimToNull(current.getBinCode());
        String currentBoundFactoryNo = StrUtil.trimToNull(current.getBoundFactoryNo());

        if (oldBoundFactoryNo != null
            && (!Objects.equals(oldBinCode, currentBinCode) || !Objects.equals(oldBoundFactoryNo, currentBoundFactoryNo)
            || !Objects.equals(current.getStorageStatus(), STORAGE_STATUS_FULL_PALLET))) {
            clearValveBinIfMatches(oldBoundFactoryNo, oldBinCode);
        }

        if (Objects.equals(current.getStorageStatus(), STORAGE_STATUS_FULL_PALLET)
            && currentBoundFactoryNo != null && currentBinCode != null) {
            bindValveToBin(currentBoundFactoryNo, current);
        }
    }

    private void bindValveToBin(String valveNo, Bin bin) {
        Valve valve = valveMapper.selectOne(Wrappers.<Valve>lambdaQuery()
            .eq(Valve::getValveNo, valveNo));
        if (valve == null) {
            throw new ServiceException("绑定出厂编号不存在");
        }
        String oldBinCode = StrUtil.trimToNull(valve.getCurrentBinCode());
        if (oldBinCode != null && !Objects.equals(oldBinCode, bin.getBinCode())) {
            markEmptyBinIfBoundTo(oldBinCode, valveNo);
        }
        valveMapper.update(null, Wrappers.<Valve>lambdaUpdate()
            .eq(Valve::getValveNo, valveNo)
            .set(Valve::getCurrentBinId, bin.getId())
            .set(Valve::getCurrentBinCode, bin.getBinCode()));
    }

    private void clearValveBinIfMatches(String valveNo, String binCode) {
        valveMapper.update(null, Wrappers.<Valve>lambdaUpdate()
            .eq(Valve::getValveNo, valveNo)
            .eq(Valve::getCurrentBinCode, binCode)
            .set(Valve::getCurrentBinId, null)
            .set(Valve::getCurrentBinCode, null));
    }

    private void normalizeStorageFields(Bin bin) {
        if (bin == null || bin.getStorageStatus() == null) {
            return;
        }
        bin.setBoundFactoryNo(normalizeBoundFactoryNo(bin.getStorageStatus(), bin.getBoundFactoryNo()));
        if (Objects.equals(bin.getStorageStatus(), STORAGE_STATUS_EMPTY_BIN)) {
            bin.setUsedCapacity(BigDecimal.ZERO);
        } else {
            bin.setUsedCapacity(BigDecimal.ONE);
        }
    }

    private String normalizeBoundFactoryNo(Integer storageStatus, String boundFactoryNo) {
        if (!Objects.equals(storageStatus, STORAGE_STATUS_FULL_PALLET)) {
            return null;
        }
        String normalizedBoundFactoryNo = StrUtil.trimToNull(boundFactoryNo);
        if (normalizedBoundFactoryNo == null) {
            throw new ServiceException("满托盘库位必须绑定出厂编号");
        }
        return normalizedBoundFactoryNo;
    }
}

