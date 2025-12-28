package com.ruoyi.wms.service;

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
import com.ruoyi.wms.domain.bo.ValveBo;
import com.ruoyi.wms.domain.entity.MaterialType;
import com.ruoyi.wms.domain.entity.Valve;
import com.ruoyi.wms.domain.vo.ValveVo;
import com.ruoyi.wms.mapper.MaterialTypeMapper;
import com.ruoyi.wms.mapper.ValveMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 阀门Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class ValveService extends ServiceImpl<ValveMapper, Valve> {

    private static final String VALVE_MATERIAL_TYPE_NAME = "阀门";

    private final ValveMapper valveMapper;
    private final MaterialTypeMapper materialTypeMapper;

    public ValveVo queryById(Long id) {
        ValveVo vo = valveMapper.selectVoById(id);
        fillMaterialTypeNames(vo);
        return vo;
    }

    public ValveVo queryByValveNo(String valveNo) {
        LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Valve::getValveNo, valveNo);
        Valve valve = valveMapper.selectOne(wrapper);
        ValveVo vo = valve != null ? MapstructUtils.convert(valve, ValveVo.class) : null;
        fillMaterialTypeNames(vo);
        return vo;
    }

    public TableDataInfo<ValveVo> queryPageList(ValveBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<Valve> lqw = buildQueryWrapper(bo);
        Page<ValveVo> result = valveMapper.selectVoPage(pageQuery.build(), lqw);
        fillMaterialTypeNames(result.getRecords());
        return TableDataInfo.build(result);
    }

    public List<ValveVo> queryList(ValveBo bo) {
        LambdaQueryWrapper<Valve> lqw = buildQueryWrapper(bo);
        List<ValveVo> list = valveMapper.selectVoList(lqw);
        fillMaterialTypeNames(list);
        return list;
    }

    /**
     * 根据状态查询阀门列表
     */
    public List<ValveVo> queryByStatus(Integer status) {
        LambdaQueryWrapper<Valve> lqw = Wrappers.lambdaQuery();
        lqw.eq(status != null, Valve::getStatus, status);
        List<ValveVo> list = valveMapper.selectVoList(lqw);
        fillMaterialTypeNames(list);
        return list;
    }

    private LambdaQueryWrapper<Valve> buildQueryWrapper(ValveBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<Valve> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getValveNo()), Valve::getValveNo, bo.getValveNo());
        lqw.eq(bo.getMaterialTypeId() != null, Valve::getMaterialTypeId, bo.getMaterialTypeId());
        lqw.like(StrUtil.isNotBlank(bo.getModel()), Valve::getModel, bo.getModel());
        lqw.like(StrUtil.isNotBlank(bo.getManufacturer()), Valve::getManufacturer, bo.getManufacturer());
        lqw.like(StrUtil.isNotBlank(bo.getBatchNo()), Valve::getBatchNo, bo.getBatchNo());
        lqw.eq(bo.getPalletId() != null, Valve::getPalletId, bo.getPalletId());
        lqw.eq(bo.getCurrentBinId() != null, Valve::getCurrentBinId, bo.getCurrentBinId());
        lqw.eq(bo.getStatus() != null, Valve::getStatus, bo.getStatus());
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(ValveBo bo) {
        validateValveNo(bo);
        Valve add = MapstructUtils.convert(bo, Valve.class);
        applyDefaultMaterialType(add);
        if (add.getStatus() == null) {
            add.setStatus(0); // 默认在库
        }
        valveMapper.insert(add);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(ValveBo bo) {
        validateValveNo(bo);
        Valve update = MapstructUtils.convert(bo, Valve.class);
        applyDefaultMaterialType(update);
        valveMapper.updateById(update);
    }

    private void applyDefaultMaterialType(Valve valve) {
        if (valve.getMaterialTypeId() != null) {
            return;
        }
        Long materialTypeId = resolveValveMaterialTypeId();
        if (materialTypeId == null) {
            throw new ServiceException("未维护物料类型：阀门");
        }
        valve.setMaterialTypeId(materialTypeId);
    }

    private Long resolveValveMaterialTypeId() {
        LambdaQueryWrapper<MaterialType> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(MaterialType::getTypeName, VALVE_MATERIAL_TYPE_NAME);
        wrapper.last("limit 1");
        MaterialType type = materialTypeMapper.selectOne(wrapper);
        return type != null ? type.getId() : null;
    }

    private void validateValveNo(ValveBo valve) {
        LambdaQueryWrapper<Valve> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(Valve::getValveNo, valve.getValveNo());
        List<Valve> valveList = valveMapper.selectList(queryWrapper);
        boolean validateNoResult = valveList.stream().anyMatch(
            it -> Objects.equals(it.getValveNo(), valve.getValveNo()) && !Objects.equals(it.getId(), valve.getId()));
        if (validateNoResult) {
            throw new ServiceException("阀门编号重复", HttpStatus.CONFLICT);
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        valveMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        valveMapper.deleteBatchIds(ids);
    }

    /**
     * 更新阀门状态
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(Long id, Integer status) {
        Valve valve = valveMapper.selectById(id);
        if (valve == null) {
            throw new ServiceException("阀门不存在");
        }
        valve.setStatus(status);
        valveMapper.updateById(valve);
    }

    /**
     * 绑定托盘
     */
    @Transactional(rollbackFor = Exception.class)
    public void bindPallet(Long valveId, Long palletId, String palletCode) {
        Valve valve = valveMapper.selectById(valveId);
        if (valve == null) {
            throw new ServiceException("阀门不存在");
        }
        valve.setPalletId(palletId);
        valve.setPalletCode(palletCode);
        valveMapper.updateById(valve);
    }

    /**
     * 更新阀门货位信息
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateValveBin(Long valveId, Long binId, String binCode) {
        Valve valve = valveMapper.selectById(valveId);
        if (valve == null) {
            throw new ServiceException("阀门不存在");
        }
        valve.setCurrentBinId(binId);
        valve.setCurrentBinCode(binCode);
        valveMapper.updateById(valve);
    }

    private void fillMaterialTypeNames(ValveVo vo) {
        if (vo == null || vo.getMaterialTypeId() == null || vo.getMaterialTypeName() != null) {
            return;
        }
        MaterialType type = materialTypeMapper.selectById(vo.getMaterialTypeId());
        if (type != null) {
            vo.setMaterialTypeName(type.getTypeName());
        }
    }

    private void fillMaterialTypeNames(List<ValveVo> list) {
        if (list == null || list.isEmpty()) {
            return;
        }
        Set<Long> typeIds = list.stream()
            .map(ValveVo::getMaterialTypeId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
        if (typeIds.isEmpty()) {
            return;
        }
        Map<Long, String> typeNameMap = materialTypeMapper.selectList(
                Wrappers.<MaterialType>lambdaQuery().in(MaterialType::getId, typeIds))
            .stream()
            .collect(Collectors.toMap(MaterialType::getId, MaterialType::getTypeName, (a, b) -> a));
        for (ValveVo vo : list) {
            if (vo.getMaterialTypeId() != null && vo.getMaterialTypeName() == null) {
                vo.setMaterialTypeName(typeNameMap.get(vo.getMaterialTypeId()));
            }
        }
    }
}

