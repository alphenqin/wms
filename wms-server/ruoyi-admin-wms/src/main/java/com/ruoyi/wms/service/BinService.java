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
import com.ruoyi.wms.domain.entity.Bin;
import com.ruoyi.wms.domain.vo.BinVo;
import com.ruoyi.wms.mapper.BinMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 货位Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class BinService extends ServiceImpl<BinMapper, Bin> {

    private final BinMapper binMapper;

    /**
     * 查询货位
     */
    public BinVo queryById(Long id) {
        return binMapper.selectVoById(id);
    }

    /**
     * 根据货位编号查询
     */
    public BinVo queryByBinCode(String binCode) {
        LambdaQueryWrapper<Bin> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Bin::getBinCode, binCode);
        Bin bin = binMapper.selectOne(wrapper);
        return bin != null ? MapstructUtils.convert(bin, BinVo.class) : null;
    }

    /**
     * 查询货位列表
     */
    public TableDataInfo<BinVo> queryPageList(BinBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<Bin> lqw = buildQueryWrapper(bo);
        Page<BinVo> result = binMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    /**
     * 查询货位列表
     */
    public List<BinVo> queryList(BinBo bo) {
        LambdaQueryWrapper<Bin> lqw = buildQueryWrapper(bo);
        return binMapper.selectVoList(lqw);
    }

    /**
     * 查询空闲货位列表
     */
    public List<BinVo> queryAvailableBins(Long warehouseId, Long areaId) {
        LambdaQueryWrapper<Bin> lqw = Wrappers.lambdaQuery();
        lqw.eq(warehouseId != null, Bin::getWarehouseId, warehouseId);
        lqw.eq(areaId != null, Bin::getAreaId, areaId);
        lqw.eq(Bin::getStatus, 0); // 0:空闲
        lqw.orderByAsc(Bin::getOrderNum);
        return binMapper.selectVoList(lqw);
    }

    /**
     * 获取最小可用库位（按库位号升序）
     */
    public BinVo queryFirstAvailableBin(Long warehouseId, Long areaId) {
        LambdaQueryWrapper<Bin> lqw = Wrappers.lambdaQuery();
        lqw.eq(warehouseId != null, Bin::getWarehouseId, warehouseId);
        lqw.eq(areaId != null, Bin::getAreaId, areaId);
        lqw.eq(Bin::getStatus, 0); // 0:空闲
        lqw.orderByAsc(Bin::getBinCode);
        lqw.last("limit 1");
        Bin bin = binMapper.selectOne(lqw);
        return bin != null ? MapstructUtils.convert(bin, BinVo.class) : null;
    }

    private LambdaQueryWrapper<Bin> buildQueryWrapper(BinBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<Bin> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getBinCode()), Bin::getBinCode, bo.getBinCode());
        lqw.like(StrUtil.isNotBlank(bo.getBinName()), Bin::getBinName, bo.getBinName());
        lqw.eq(bo.getWarehouseId() != null, Bin::getWarehouseId, bo.getWarehouseId());
        lqw.eq(bo.getAreaId() != null, Bin::getAreaId, bo.getAreaId());
        lqw.eq(bo.getBinType() != null, Bin::getBinType, bo.getBinType());
        lqw.eq(bo.getTemperatureZone() != null, Bin::getTemperatureZone, bo.getTemperatureZone());
        lqw.eq(bo.getStatus() != null, Bin::getStatus, bo.getStatus());
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
        binMapper.insert(add);
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
        Bin update = MapstructUtils.convert(bo, Bin.class);
        binMapper.updateById(update);
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
        if (bin != null && bin.getStatus() != null && bin.getStatus() == 1) {
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
}

