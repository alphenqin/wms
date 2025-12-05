package com.ruoyi.wms.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.ScanTaskBo;
import com.ruoyi.wms.domain.entity.ScanTask;
import com.ruoyi.wms.domain.vo.ScanTaskVo;
import com.ruoyi.wms.mapper.ScanTaskMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * 扫码任务Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class ScanTaskService extends ServiceImpl<ScanTaskMapper, ScanTask> {

    private final ScanTaskMapper scanTaskMapper;

    public ScanTaskVo queryById(Long id) {
        return scanTaskMapper.selectVoById(id);
    }

    public TableDataInfo<ScanTaskVo> queryPageList(ScanTaskBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<ScanTask> lqw = buildQueryWrapper(bo);
        Page<ScanTaskVo> result = scanTaskMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<ScanTaskVo> queryList(ScanTaskBo bo) {
        LambdaQueryWrapper<ScanTask> lqw = buildQueryWrapper(bo);
        return scanTaskMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<ScanTask> buildQueryWrapper(ScanTaskBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<ScanTask> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getTaskNo()), ScanTask::getTaskNo, bo.getTaskNo());
        lqw.eq(bo.getTaskType() != null, ScanTask::getTaskType, bo.getTaskType());
        lqw.eq(StrUtil.isNotBlank(bo.getBarcode()), ScanTask::getBarcode, bo.getBarcode());
        lqw.eq(StrUtil.isNotBlank(bo.getOperator()), ScanTask::getOperator, bo.getOperator());
        lqw.eq(StrUtil.isNotBlank(bo.getPdaDeviceNo()), ScanTask::getPdaDeviceNo, bo.getPdaDeviceNo());
        lqw.eq(bo.getStatus() != null, ScanTask::getStatus, bo.getStatus());
        lqw.orderByDesc(ScanTask::getCreateTime);
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(ScanTaskBo bo) {
        ScanTask add = MapstructUtils.convert(bo, ScanTask.class);
        if (add.getStatus() == null) {
            add.setStatus(0); // 默认待处理
        }
        if (add.getTaskNo() == null) {
            add.setTaskNo(generateTaskNo());
        }
        scanTaskMapper.insert(add);
    }

    private String generateTaskNo() {
        return "SCAN" + System.currentTimeMillis();
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(ScanTaskBo bo) {
        ScanTask update = MapstructUtils.convert(bo, ScanTask.class);
        scanTaskMapper.updateById(update);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        scanTaskMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        scanTaskMapper.deleteBatchIds(ids);
    }

    /**
     * 更新任务状态
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(Long id, Integer status, String result, String errorMsg) {
        ScanTask task = scanTaskMapper.selectById(id);
        if (task == null) {
            return;
        }
        task.setStatus(status);
        task.setResult(result);
        task.setErrorMsg(errorMsg);
        scanTaskMapper.updateById(task);
    }
}

