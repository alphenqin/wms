package com.ruoyi.wms.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.PdaLogBo;
import com.ruoyi.wms.domain.entity.PdaLog;
import com.ruoyi.wms.domain.vo.PdaLogVo;
import com.ruoyi.wms.mapper.PdaLogMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * PDA日志Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class PdaLogService extends ServiceImpl<PdaLogMapper, PdaLog> {

    private final PdaLogMapper pdaLogMapper;

    public PdaLogVo queryById(Long id) {
        return pdaLogMapper.selectVoById(id);
    }

    public TableDataInfo<PdaLogVo> queryPageList(PdaLogBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<PdaLog> lqw = buildQueryWrapper(bo);
        Page<PdaLogVo> result = pdaLogMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<PdaLogVo> queryList(PdaLogBo bo) {
        LambdaQueryWrapper<PdaLog> lqw = buildQueryWrapper(bo);
        return pdaLogMapper.selectVoList(lqw);
    }

    /**
     * 查询错误日志
     */
    public List<PdaLogVo> queryErrorLogs(String pdaDeviceNo) {
        LambdaQueryWrapper<PdaLog> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(pdaDeviceNo), PdaLog::getPdaDeviceNo, pdaDeviceNo);
        lqw.eq(PdaLog::getLogLevel, "ERROR");
        lqw.orderByDesc(PdaLog::getCreateTime);
        return pdaLogMapper.selectVoList(lqw);
    }

    /**
     * 查询网络失败记录
     */
    public List<PdaLogVo> queryNetworkFailures(String pdaDeviceNo) {
        LambdaQueryWrapper<PdaLog> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(pdaDeviceNo), PdaLog::getPdaDeviceNo, pdaDeviceNo);
        lqw.eq(PdaLog::getLogType, 3); // 网络失败记录
        lqw.orderByDesc(PdaLog::getCreateTime);
        return pdaLogMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<PdaLog> buildQueryWrapper(PdaLogBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<PdaLog> lqw = Wrappers.lambdaQuery();
        lqw.eq(bo.getLogType() != null, PdaLog::getLogType, bo.getLogType());
        lqw.eq(StrUtil.isNotBlank(bo.getPdaDeviceNo()), PdaLog::getPdaDeviceNo, bo.getPdaDeviceNo());
        lqw.eq(StrUtil.isNotBlank(bo.getOperator()), PdaLog::getOperator, bo.getOperator());
        lqw.eq(StrUtil.isNotBlank(bo.getLogLevel()), PdaLog::getLogLevel, bo.getLogLevel());
        lqw.like(StrUtil.isNotBlank(bo.getLogContent()), PdaLog::getLogContent, bo.getLogContent());
        lqw.orderByDesc(PdaLog::getCreateTime);
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(PdaLogBo bo) {
        PdaLog add = MapstructUtils.convert(bo, PdaLog.class);
        pdaLogMapper.insert(add);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(PdaLogBo bo) {
        PdaLog update = MapstructUtils.convert(bo, PdaLog.class);
        pdaLogMapper.updateById(update);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        pdaLogMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        pdaLogMapper.deleteBatchIds(ids);
    }
}

