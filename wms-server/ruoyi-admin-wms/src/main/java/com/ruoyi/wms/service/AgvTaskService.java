package com.ruoyi.wms.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.AgvTaskBo;
import com.ruoyi.wms.domain.entity.AgvTask;
import com.ruoyi.wms.domain.vo.AgvTaskVo;
import com.ruoyi.wms.mapper.AgvTaskMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * AGV任务Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class AgvTaskService extends ServiceImpl<AgvTaskMapper, AgvTask> {

    private final AgvTaskMapper agvTaskMapper;

    public AgvTaskVo queryById(Long id) {
        return agvTaskMapper.selectVoById(id);
    }

    public AgvTaskVo queryByTaskNo(String taskNo) {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskNo, taskNo);
        AgvTask task = agvTaskMapper.selectOne(wrapper);
        return task != null ? MapstructUtils.convert(task, AgvTaskVo.class) : null;
    }

    public AgvTaskVo queryByAgvTaskId(String agvTaskId) {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getAgvTaskId, agvTaskId);
        AgvTask task = agvTaskMapper.selectOne(wrapper);
        return task != null ? MapstructUtils.convert(task, AgvTaskVo.class) : null;
    }

    public TableDataInfo<AgvTaskVo> queryPageList(AgvTaskBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<AgvTask> lqw = buildQueryWrapper(bo);
        Page<AgvTaskVo> result = agvTaskMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<AgvTaskVo> queryList(AgvTaskBo bo) {
        LambdaQueryWrapper<AgvTask> lqw = buildQueryWrapper(bo);
        return agvTaskMapper.selectVoList(lqw);
    }

    /**
     * 根据状态查询任务列表
     */
    public List<AgvTaskVo> queryByStatus(Integer status) {
        LambdaQueryWrapper<AgvTask> lqw = Wrappers.lambdaQuery();
        lqw.eq(status != null, AgvTask::getStatus, status);
        lqw.orderByDesc(AgvTask::getCreateTime);
        return agvTaskMapper.selectVoList(lqw);
    }

    /**
     * 查询执行中的任务
     */
    public List<AgvTaskVo> queryExecutingTasks() {
        LambdaQueryWrapper<AgvTask> lqw = Wrappers.lambdaQuery();
        lqw.in(AgvTask::getStatus, 0, 1); // PENDING 或 EXECUTING
        lqw.orderByDesc(AgvTask::getCreateTime);
        return agvTaskMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<AgvTask> buildQueryWrapper(AgvTaskBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<AgvTask> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getTaskNo()), AgvTask::getTaskNo, bo.getTaskNo());
        lqw.eq(bo.getTaskType() != null, AgvTask::getTaskType, bo.getTaskType());
        lqw.eq(StrUtil.isNotBlank(bo.getBizOrderNo()), AgvTask::getBizOrderNo, bo.getBizOrderNo());
        lqw.eq(bo.getBizOrderId() != null, AgvTask::getBizOrderId, bo.getBizOrderId());
        lqw.eq(StrUtil.isNotBlank(bo.getPalletCode()), AgvTask::getPalletCode, bo.getPalletCode());
        lqw.eq(StrUtil.isNotBlank(bo.getAgvTaskId()), AgvTask::getAgvTaskId, bo.getAgvTaskId());
        lqw.eq(bo.getStatus() != null, AgvTask::getStatus, bo.getStatus());
        lqw.eq(StrUtil.isNotBlank(bo.getAgvDeviceNo()), AgvTask::getAgvDeviceNo, bo.getAgvDeviceNo());
        lqw.orderByDesc(AgvTask::getCreateTime);
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(AgvTaskBo bo) {
        AgvTask add = MapstructUtils.convert(bo, AgvTask.class);
        if (add.getTaskNo() == null) {
            String taskNo = generateTaskNo(bo.getTaskType());
            add.setTaskNo(taskNo);
            bo.setTaskNo(taskNo);
        }
        if (add.getStatus() == null) {
            add.setStatus(0); // 默认待处理
        }
        if (add.getDispatchTime() == null) {
            add.setDispatchTime(new Date());
        }
        agvTaskMapper.insert(add);
    }

    /**
     * 生成任务编号
     * 入库任务：I开头，送检任务：C开头，回库任务：R开头，出库任务：O开头
     */
    private String generateTaskNo(Integer taskType) {
        String prefix = "T";
        switch (taskType) {
            case 1: prefix = "I"; break; // 入库
            case 2: prefix = "C"; break; // 送检
            case 3: prefix = "R"; break; // 回库
            case 4: prefix = "O"; break; // 出库
        }
        return prefix + System.currentTimeMillis();
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(AgvTaskBo bo) {
        AgvTask update = MapstructUtils.convert(bo, AgvTask.class);
        agvTaskMapper.updateById(update);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        agvTaskMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        agvTaskMapper.deleteBatchIds(ids);
    }

    /**
     * 更新任务状态（AGV回调使用）
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateTaskStatus(String agvTaskId, Integer status, String agvDeviceNo, String agvResponse, String errorMsg) {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getAgvTaskId, agvTaskId);
        AgvTask task = agvTaskMapper.selectOne(wrapper);
        if (task == null) {
            return;
        }
        task.setStatus(status);
        if (StrUtil.isNotBlank(agvDeviceNo)) {
            task.setAgvDeviceNo(agvDeviceNo);
        }
        if (StrUtil.isNotBlank(agvResponse)) {
            task.setAgvResponse(agvResponse);
        }
        if (StrUtil.isNotBlank(errorMsg)) {
            task.setErrorMsg(errorMsg);
        }
        if (status == 2 || status == 3) { // FINISHED 或 FAILED
            task.setFinishTime(new Date());
        }
        agvTaskMapper.updateById(task);
    }

    /**
     * 更新任务状态（通过任务编号）
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateTaskStatusByTaskNo(String taskNo, Integer status, String errorMsg) {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskNo, taskNo);
        AgvTask task = agvTaskMapper.selectOne(wrapper);
        if (task == null) {
            return;
        }
        task.setStatus(status);
        if (StrUtil.isNotBlank(errorMsg)) {
            task.setErrorMsg(errorMsg);
        }
        if (status == 2 || status == 3) { // FINISHED 或 FAILED
            task.setFinishTime(new Date());
        }
        agvTaskMapper.updateById(task);
    }

    /**
     * 取消任务
     */
    @Transactional(rollbackFor = Exception.class)
    public void cancelTask(Long id) {
        AgvTask task = agvTaskMapper.selectById(id);
        if (task == null) {
            return;
        }
        if (task.getStatus() == 2 || task.getStatus() == 3) {
            // 已完成或失败的任务不能取消
            return;
        }
        task.setStatus(4); // CANCELLED
        task.setFinishTime(new Date());
        agvTaskMapper.updateById(task);
    }
}

