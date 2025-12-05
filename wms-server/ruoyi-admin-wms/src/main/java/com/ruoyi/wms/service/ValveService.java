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
import com.ruoyi.wms.domain.entity.Valve;
import com.ruoyi.wms.domain.vo.ValveVo;
import com.ruoyi.wms.mapper.ValveMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 阀门Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class ValveService extends ServiceImpl<ValveMapper, Valve> {

    private final ValveMapper valveMapper;

    public ValveVo queryById(Long id) {
        return valveMapper.selectVoById(id);
    }

    public ValveVo queryByValveNo(String valveNo) {
        LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Valve::getValveNo, valveNo);
        Valve valve = valveMapper.selectOne(wrapper);
        return valve != null ? MapstructUtils.convert(valve, ValveVo.class) : null;
    }

    public TableDataInfo<ValveVo> queryPageList(ValveBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<Valve> lqw = buildQueryWrapper(bo);
        Page<ValveVo> result = valveMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<ValveVo> queryList(ValveBo bo) {
        LambdaQueryWrapper<Valve> lqw = buildQueryWrapper(bo);
        return valveMapper.selectVoList(lqw);
    }

    /**
     * 根据状态查询阀门列表
     */
    public List<ValveVo> queryByStatus(Integer status) {
        LambdaQueryWrapper<Valve> lqw = Wrappers.lambdaQuery();
        lqw.eq(status != null, Valve::getStatus, status);
        return valveMapper.selectVoList(lqw);
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
        if (add.getStatus() == null) {
            add.setStatus(0); // 默认在库
        }
        valveMapper.insert(add);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(ValveBo bo) {
        validateValveNo(bo);
        Valve update = MapstructUtils.convert(bo, Valve.class);
        valveMapper.updateById(update);
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
}

