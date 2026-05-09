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

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.Date;
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
        lqw.like(StrUtil.isNotBlank(bo.getValveNo()), Valve::getValveNo, bo.getValveNo());
        lqw.like(StrUtil.isNotBlank(bo.getManufacturer()), Valve::getManufacturer, bo.getManufacturer());
        lqw.like(StrUtil.isNotBlank(bo.getBatchNo()), Valve::getBatchNo, bo.getBatchNo());
        lqw.eq(bo.getPalletId() != null, Valve::getPalletId, bo.getPalletId());
        lqw.like(StrUtil.isNotBlank(bo.getPalletCode()), Valve::getPalletCode, bo.getPalletCode());
        lqw.eq(bo.getCurrentBinId() != null, Valve::getCurrentBinId, bo.getCurrentBinId());
        lqw.like(StrUtil.isNotBlank(bo.getCurrentBinCode()), Valve::getCurrentBinCode, bo.getCurrentBinCode());
        lqw.eq(bo.getStatus() != null, Valve::getStatus, bo.getStatus());
        LocalDateTime beginCreateTime = parseBeginOfDay(params.get("beginCreateTime"));
        LocalDateTime endCreateTime = parseEndOfDay(params.get("endCreateTime"));
        Date beginOutboundTime = parseBeginDate(params.get("beginOutboundTime"));
        Date endOutboundTime = parseEndDate(params.get("endOutboundTime"));
        lqw.ge(beginCreateTime != null, Valve::getCreateTime, beginCreateTime);
        lqw.le(endCreateTime != null, Valve::getCreateTime, endCreateTime);
        lqw.ge(beginOutboundTime != null, Valve::getOutboundTime, beginOutboundTime);
        lqw.le(endOutboundTime != null, Valve::getOutboundTime, endOutboundTime);
        lqw.orderByAsc(Valve::getValveNo);
        return lqw;
    }

    private LocalDate parseLocalDate(Object value) {
        if (value instanceof LocalDate localDate) {
            return localDate;
        }
        if (value instanceof LocalDateTime localDateTime) {
            return localDateTime.toLocalDate();
        }
        String text = value == null ? null : StrUtil.trimToNull(String.valueOf(value));
        if (text == null) {
            return null;
        }
        return LocalDate.parse(text.length() > 10 ? text.substring(0, 10) : text);
    }

    private LocalDateTime parseBeginOfDay(Object value) {
        LocalDate localDate = parseLocalDate(value);
        return localDate == null ? null : localDate.atStartOfDay();
    }

    private LocalDateTime parseEndOfDay(Object value) {
        LocalDate localDate = parseLocalDate(value);
        return localDate == null ? null : localDate.atTime(LocalTime.MAX);
    }

    private Date toDate(LocalDateTime localDateTime) {
        return localDateTime == null ? null : Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
    }

    private Date parseBeginDate(Object value) {
        return toDate(parseBeginOfDay(value));
    }

    private Date parseEndDate(Object value) {
        return toDate(parseEndOfDay(value));
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(ValveBo bo) {
        validateValveNo(bo);
        Valve add = MapstructUtils.convert(bo, Valve.class);
        if (add.getStatus() == null) {
            add.setStatus(0); // 默认在库
        }
        if (Objects.equals(add.getStatus(), 3) && add.getOutboundTime() == null) {
            add.setOutboundTime(new Date());
        }
        valveMapper.insert(add);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(ValveBo bo) {
        validateValveNo(bo);
        Valve current = valveMapper.selectById(bo.getId());
        if (current == null) {
            throw new ServiceException("阀门不存在");
        }
        Valve update = MapstructUtils.convert(bo, Valve.class);
        valveMapper.updateById(update);
        valveMapper.update(null, Wrappers.lambdaUpdate(Valve.class)
            .eq(Valve::getId, bo.getId())
            .set(Valve::getCreateTime, bo.getCreateTime())
            .set(Valve::getOutboundTime, bo.getOutboundTime()));
    }

    private void validateValveNo(ValveBo valve) {
        LambdaQueryWrapper<Valve> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(Valve::getValveNo, valve.getValveNo());
        List<Valve> valveList = valveMapper.selectList(queryWrapper);
        boolean validateNoResult = valveList.stream().anyMatch(
            it -> Objects.equals(it.getValveNo(), valve.getValveNo()) && !Objects.equals(it.getId(), valve.getId()));
        if (validateNoResult) {
            throw new ServiceException("出厂编号重复", HttpStatus.CONFLICT);
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
        if (Objects.equals(status, 3) && valve.getOutboundTime() == null) {
            valve.setOutboundTime(new Date());
        }
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

