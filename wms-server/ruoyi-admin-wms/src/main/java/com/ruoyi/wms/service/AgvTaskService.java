package com.ruoyi.wms.service;

import cn.hutool.core.map.MapUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.AgvOpenTaskBo;
import com.ruoyi.wms.domain.bo.AgvTaskBo;
import com.ruoyi.wms.domain.entity.AgvTask;
import com.ruoyi.wms.domain.vo.AgvTaskVo;
import com.ruoyi.wms.mapper.AgvTaskMapper;
import com.ruoyi.wms.mapper.ValveMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
@Slf4j
@RequiredArgsConstructor
@Service
public class AgvTaskService extends ServiceImpl<AgvTaskMapper, AgvTask> {

    private final AgvTaskMapper agvTaskMapper;
    private final AgvOpenTaskService agvOpenTaskService;
    private final ValveMapper valveMapper;
    private static final String INSPECTION_EMPTY_RETURN_REMARK = "INSPECTION_EMPTY_RETURN";
    private static final String INSPECTION_EMPTY_RETURN_REMARK_LEGACY = "EMPTY_RETURN_FROM_INSPECTION";
    private static final String OUTBOUND_EMPTY_RETURN_REMARK = "OUTBOUND_EMPTY_RETURN";
    private static final String RETURN_CALL_PALLET_REMARK = "RETURN_CALL_PALLET";
    private static final String VALVE_RETURN_REMARK = "VALVE_RETURN";

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
        String taskSubType = StrUtil.trimToNull(bo.getTaskSubType());
        if (StrUtil.isNotBlank(taskSubType)) {
            switch (taskSubType.toUpperCase()) {
                case "CALL_INBOUND":
                    lqw.eq(AgvTask::getTaskType, 1);
                    break;
                case "CALL_SEND_INSPECTION":
                    lqw.eq(AgvTask::getTaskType, 2);
                    break;
                case "INSPECTION_EMPTY_RETURN":
                    lqw.eq(AgvTask::getTaskType, 3);
                    lqw.in(AgvTask::getRemark, INSPECTION_EMPTY_RETURN_REMARK, INSPECTION_EMPTY_RETURN_REMARK_LEGACY);
                    break;
                case "RETURN_CALL_PALLET":
                    lqw.eq(AgvTask::getTaskType, 3);
                    lqw.eq(AgvTask::getRemark, RETURN_CALL_PALLET_REMARK);
                    break;
                case "VALVE_RETURN":
                    lqw.eq(AgvTask::getTaskType, 3);
                    lqw.eq(AgvTask::getRemark, VALVE_RETURN_REMARK);
                    break;
                case "CALL_OUTBOUND":
                    lqw.eq(AgvTask::getTaskType, 4);
                    break;
                case "OUTBOUND_EMPTY_RETURN":
                    lqw.eq(AgvTask::getTaskType, 3);
                    lqw.eq(AgvTask::getRemark, OUTBOUND_EMPTY_RETURN_REMARK);
                    break;
                default:
                    break;
            }
        } else {
            lqw.eq(bo.getTaskType() != null, AgvTask::getTaskType, bo.getTaskType());
        }
        lqw.eq(StrUtil.isNotBlank(bo.getBizOrderNo()), AgvTask::getBizOrderNo, bo.getBizOrderNo());
        lqw.eq(bo.getBizOrderId() != null, AgvTask::getBizOrderId, bo.getBizOrderId());
        lqw.eq(StrUtil.isNotBlank(bo.getPalletCode()), AgvTask::getPalletCode, bo.getPalletCode());
        lqw.eq(StrUtil.isNotBlank(bo.getTaskSource()), AgvTask::getTaskSource, bo.getTaskSource());
        lqw.eq(StrUtil.isNotBlank(bo.getPdaDeviceNo()), AgvTask::getPdaDeviceNo, bo.getPdaDeviceNo());
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
        if (StrUtil.isBlank(add.getTaskSource())) {
            add.setTaskSource("WMS");
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

        // 任务完成时更新阀门状态
        if (status == 2 && task.getTaskType() != null && task.getPalletCode() != null) {
            Integer valveStatus = null;
            if (task.getTaskType() == 3) {
                // 回库任务完成，阀门状态更新为IN_STOCK（在库）
                String remark = task.getRemark();
                boolean isInspectionEmptyReturn = StrUtil.equalsIgnoreCase(remark, INSPECTION_EMPTY_RETURN_REMARK)
                    || StrUtil.equalsIgnoreCase(remark, INSPECTION_EMPTY_RETURN_REMARK_LEGACY);
                if (!isInspectionEmptyReturn) {
                    valveStatus = 0;
                }
            } else if (task.getTaskType() == 4) {
                // 出库任务完成，阀门状态更新为OUTBOUND（已出库）
                valveStatus = 3;
            }
            if (valveStatus != null) {
                updateValveStatusByPalletCode(task.getPalletCode(), valveStatus);
            }
        }
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

    /**
     * 取消任务并通知AGV调度系统清空任务
     */
    @Transactional(rollbackFor = Exception.class)
    public void cancelTaskWithAgv(Long id) {
        AgvTask task = agvTaskMapper.selectById(id);
        if (task == null) {
            return;
        }
        if (task.getStatus() == 2 || task.getStatus() == 3) {
            // 已完成或失败的任务不能取消
            return;
        }
        String outId = StrUtil.trimToNull(task.getTaskNo());
        if (StrUtil.isBlank(outId)) {
            throw new ServiceException("任务编号不能为空，无法取消");
        }
        AgvOpenTaskBo openTaskBo = new AgvOpenTaskBo();
        openTaskBo.setTaskType("13");
        openTaskBo.setClearOutId(outId);
        openTaskBo.setOutId(outId);
        log.info("AGV取消请求 -> outID={}", outId);
        try {
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(openTaskBo);
            String code = MapUtil.getStr(agvResp, "code");
            if (!"20000".equals(code)) {
                String message = MapUtil.getStr(agvResp, "message");
                log.warn("AGV取消请求返回失败 <- outID={}, code={}, message={}", outId, code, message);
            } else {
                log.info("AGV取消请求成功 <- outID={}, code={}", outId, code);
            }
        } catch (Exception e) {
            log.warn("AGV取消请求异常 <- outID={}, error={}", outId, e.getMessage());
        }
        task.setStatus(4); // CANCELLED
        task.setFinishTime(new Date());
        agvTaskMapper.updateById(task);
    }

    /**
     * 根据托盘编号更新阀门状态
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateValveStatusByPalletCode(String palletCode, Integer status) {
        if (StrUtil.isBlank(palletCode)) {
            return;
        }
        // 通过托盘编号查找阀门
        LambdaQueryWrapper<com.ruoyi.wms.domain.entity.Valve> valveWrapper = Wrappers.lambdaQuery();
        valveWrapper.eq(com.ruoyi.wms.domain.entity.Valve::getPalletCode, palletCode);
        valveWrapper.orderByDesc(com.ruoyi.wms.domain.entity.Valve::getUpdateTime);
        valveWrapper.last("limit 1");
        com.ruoyi.wms.domain.entity.Valve valve = valveMapper.selectOne(valveWrapper);
        if (valve != null) {
            valve.setStatus(status);
            valveMapper.updateById(valve);
        }
    }
}
