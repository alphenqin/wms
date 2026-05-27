package com.ruoyi.wms.task;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.wms.domain.entity.AgvOpenTask;
import com.ruoyi.wms.domain.entity.AgvTask;
import com.ruoyi.wms.domain.vo.PalletVo;
import com.ruoyi.wms.mapper.AgvOpenTaskMapper;
import com.ruoyi.wms.mapper.AgvTaskMapper;
import com.ruoyi.wms.service.AgvTaskService;
import com.ruoyi.wms.service.PalletService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * AGV主任务状态补偿：当开放接口任务都完成但主任务仍为执行中时，自动修正主任务状态。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AgvTaskCompensateJob {

    private static final int TASK_INBOUND = 1;
    private static final int TASK_INSPECTION = 2;
    private static final int TASK_RETURN = 3;
    private static final int TASK_OUTBOUND = 4;

    private static final String STATUS_FINISHED = "08";
    private static final String STATUS_CLEARED = "09";

    private static final String INSPECTION_EMPTY_RETURN_REMARK = "INSPECTION_EMPTY_RETURN";
    private static final String INSPECTION_EMPTY_RETURN_REMARK_LEGACY = "EMPTY_RETURN_FROM_INSPECTION";
    private static final String OUTBOUND_EMPTY_RETURN_REMARK = "OUTBOUND_EMPTY_RETURN";
    private static final String OUTSIDE_EMPTY_RETURN_REMARK = "OUTSIDE_EMPTY_RETURN";
    private static final String RETURN_CALL_PALLET_REMARK = "RETURN_CALL_PALLET";
    private static final String VALVE_RETURN_REMARK = "VALVE_RETURN";

    private final AgvTaskMapper agvTaskMapper;
    private final AgvOpenTaskMapper agvOpenTaskMapper;
    private final AgvTaskService agvTaskService;
    private final PalletService palletService;

    @Value("${wms.agv.compensate-enabled:true}")
    private boolean enabled;

    @Value("${wms.agv.compensate-min-age-ms:60000}")
    private long minAgeMs;

    @Scheduled(fixedDelayString = "${wms.agv.compensate-interval-ms:60000}")
    public void compensateAgvTaskStatus() {
        if (!enabled) {
            return;
        }
        Date deadline = new Date(System.currentTimeMillis() - Math.max(0, minAgeMs));
        LambdaQueryWrapper<AgvTask> taskWrapper = Wrappers.lambdaQuery();
        taskWrapper.in(AgvTask::getTaskType, TASK_INBOUND, TASK_INSPECTION, TASK_RETURN, TASK_OUTBOUND);
        taskWrapper.in(AgvTask::getStatus, 0, 1);
        taskWrapper.lt(AgvTask::getCreateTime, deadline);
        List<AgvTask> tasks = agvTaskMapper.selectList(taskWrapper);
        if (tasks.isEmpty()) {
            return;
        }
        for (AgvTask task : tasks) {
            compensateTask(task);
        }
    }

    private void compensateTask(AgvTask task) {
        String taskNo = task.getTaskNo();
        if (taskNo == null || taskNo.trim().isEmpty()) {
            return;
        }
        List<TaskStepRef> stepRefs = buildStepRefs(task);
        if (stepRefs.isEmpty()) {
            return;
        }
        List<String> outIds = new ArrayList<>();
        for (TaskStepRef stepRef : stepRefs) {
            outIds.add(stepRef.outId);
        }
        LambdaQueryWrapper<AgvOpenTask> openWrapper = Wrappers.lambdaQuery();
        openWrapper.in(AgvOpenTask::getOutId, outIds);
        List<AgvOpenTask> openTasks = agvOpenTaskMapper.selectList(openWrapper);
        if (openTasks.size() < outIds.size()) {
            return;
        }
        Map<String, AgvOpenTask> openTaskMap = new HashMap<>();
        for (AgvOpenTask openTask : openTasks) {
            openTaskMap.put(openTask.getOutId(), openTask);
        }
        String clearedStep = null;
        boolean allFinished = true;
        for (TaskStepRef stepRef : stepRefs) {
            AgvOpenTask step = openTaskMap.get(stepRef.outId);
            if (step == null || step.getStatus() == null) {
                allFinished = false;
                break;
            }
            if (STATUS_CLEARED.equals(step.getStatus())) {
                clearedStep = stepRef.label;
                allFinished = false;
                break;
            }
            if (!STATUS_FINISHED.equals(step.getStatus())) {
                allFinished = false;
                break;
            }
        }
        if (clearedStep != null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, buildClearedMessage(task, clearedStep));
            log.warn("Task cleared: taskNo={}, step={}", taskNo, clearedStep);
            return;
        }
        if (allFinished) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
            applyCompletionSideEffects(task);
            log.info("Task compensated to completed: taskNo={}, type={}", taskNo, task.getTaskType());
        }
    }

    private List<TaskStepRef> buildStepRefs(AgvTask task) {
        String taskNo = task.getTaskNo();
        if (taskNo == null || taskNo.trim().isEmpty()) {
            return Collections.emptyList();
        }
        Integer taskType = task.getTaskType();
        if (TASK_INBOUND == taskType) {
            return Arrays.asList(
                new TaskStepRef(taskNo + "-1", "1"),
                new TaskStepRef(taskNo + "-2", "2"),
                new TaskStepRef(taskNo + "-4", "4")
            );
        }
        if (TASK_INSPECTION == taskType) {
            return Arrays.asList(
                new TaskStepRef(taskNo + "-S1", "1"),
                new TaskStepRef(taskNo + "-S2", "2")
            );
        }
        if (TASK_OUTBOUND == taskType) {
            return Arrays.asList(
                new TaskStepRef(taskNo + "-O1", "1"),
                new TaskStepRef(taskNo + "-O2", "2")
            );
        }
        if (TASK_RETURN == taskType) {
            String remark = task.getRemark();
            if (remark != null) {
                if (INSPECTION_EMPTY_RETURN_REMARK.equalsIgnoreCase(remark)
                    || INSPECTION_EMPTY_RETURN_REMARK_LEGACY.equalsIgnoreCase(remark)) {
                    return Arrays.asList(
                        new TaskStepRef(taskNo + "-ER1", "1"),
                        new TaskStepRef(taskNo + "-ER2", "2")
                    );
                }
                if (OUTBOUND_EMPTY_RETURN_REMARK.equalsIgnoreCase(remark)) {
                    return Arrays.asList(
                        new TaskStepRef(taskNo + "-OR1", "1"),
                        new TaskStepRef(taskNo + "-OR2", "2")
                    );
                }
                if (OUTSIDE_EMPTY_RETURN_REMARK.equalsIgnoreCase(remark)) {
                    return Arrays.asList(
                        new TaskStepRef(taskNo + "-ER1", "1"),
                        new TaskStepRef(taskNo + "-ER2", "2")
                    );
                }
                if (RETURN_CALL_PALLET_REMARK.equalsIgnoreCase(remark)) {
                    return Arrays.asList(
                        new TaskStepRef(taskNo + "-RC1", "1"),
                        new TaskStepRef(taskNo + "-RC2", "2")
                    );
                }
                if (VALVE_RETURN_REMARK.equalsIgnoreCase(remark)) {
                    return Arrays.asList(
                        new TaskStepRef(taskNo + "-VR1", "1"),
                        new TaskStepRef(taskNo + "-VR2", "2")
                    );
                }
            }
            return Arrays.asList(new TaskStepRef(taskNo, "1"));
        }
        return Arrays.asList(new TaskStepRef(taskNo, "1"));
    }

    private String buildClearedMessage(AgvTask task, String stepIndex) {
        Integer taskType = task.getTaskType();
        if (TASK_INBOUND == taskType) {
            return "入库流程步骤" + stepIndex + "被清空";
        }
        if (TASK_INSPECTION == taskType) {
            return "送检流程步骤" + stepIndex + "被清空";
        }
        if (TASK_OUTBOUND == taskType) {
            return "出库流程步骤" + stepIndex + "被清空";
        }
        return "任务步骤" + stepIndex + "被清空";
    }

    private void applyCompletionSideEffects(AgvTask task) {
        Integer taskType = task.getTaskType();
        if (TASK_INSPECTION == taskType) {
            if (task.getPalletCode() != null && !task.getPalletCode().trim().isEmpty()) {
                agvTaskService.updateValveStatusByTaskReference(task.getBizOrderNo(), task.getPalletCode(), 2);
            }
            return;
        }
        if (TASK_OUTBOUND == taskType) {
            if (task.getPalletCode() != null && !task.getPalletCode().trim().isEmpty()) {
                agvTaskService.updateValveStatusByTaskReference(task.getBizOrderNo(), task.getPalletCode(), 3);
            }
            unbindPalletSilently(task.getPalletCode());
        }
    }

    private void unbindPalletSilently(String palletNo) {
        if (palletNo == null || palletNo.trim().isEmpty()) {
            return;
        }
        try {
            PalletVo palletVo = palletService.queryByPalletCode(palletNo);
            if (palletVo != null && palletVo.getId() != null) {
                palletService.unbindMaterial(palletVo.getId());
            }
        } catch (Exception e) {
            log.warn("托盘置空失败: {}", e.getMessage());
        }
    }

    private static class TaskStepRef {
        private final String outId;
        private final String label;

        private TaskStepRef(String outId, String label) {
            this.outId = outId;
            this.label = label;
        }
    }
}
