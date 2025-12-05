package com.ruoyi.wms.service;

import cn.hutool.core.util.StrUtil;
import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.wms.domain.bo.AgvTaskBo;
import com.ruoyi.wms.domain.vo.AgvTaskVo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

/**
 * AGV集成服务
 * 负责与AGV调度系统对接
 *
 * @author wms
 * @date 2024
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class AgvIntegrationService {

    private final AgvTaskService agvTaskService;
    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${agv.api.url:http://localhost:8080/agv}")
    private String agvApiUrl;

    @Value("${agv.api.key:}")
    private String agvApiKey;

    @Value("${agv.api.token:}")
    private String agvApiToken;

    /**
     * 下发入库任务到AGV
     *
     * @param palletCode 托盘编号
     * @param fromBinCode 起始货位（通常是入库口）
     * @param toBinCode 目标货位
     * @param bizOrderNo 业务单号
     * @param bizOrderId 业务单ID
     * @return AGV任务ID
     */
    @Transactional(rollbackFor = Exception.class)
    public String dispatchInboundTask(String palletCode, String fromBinCode, String toBinCode,
                                      String bizOrderNo, Long bizOrderId) {
        // 创建AGV任务记录
        AgvTaskBo taskBo = new AgvTaskBo();
        taskBo.setTaskType(1); // 入库任务
        taskBo.setPalletCode(palletCode);
        taskBo.setFromBinCode(fromBinCode);
        taskBo.setToBinCode(toBinCode);
        taskBo.setBizOrderNo(bizOrderNo);
        taskBo.setBizOrderId(bizOrderId);
        agvTaskService.insertByBo(taskBo);

        AgvTaskVo task = agvTaskService.queryByTaskNo(taskBo.getTaskNo());

        // 调用AGV接口
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("outID", task.getTaskNo());
        requestBody.put("palletCode", palletCode);
        requestBody.put("fromBinCode", fromBinCode);
        requestBody.put("toBinCode", toBinCode);
        requestBody.put("taskType", "INBOUND");

        try {
            String agvTaskId = callAgvApi("/task/dispatch", requestBody);
            
            // 更新任务记录
            AgvTaskBo updateBo = new AgvTaskBo();
            updateBo.setId(task.getId());
            updateBo.setAgvTaskId(agvTaskId);
            updateBo.setStatus(1); // EXECUTING
            agvTaskService.updateByBo(updateBo);

            return agvTaskId;
        } catch (Exception e) {
            log.error("下发入库任务失败", e);
            // 更新任务状态为失败
            agvTaskService.updateTaskStatusByTaskNo(task.getTaskNo(), 3, "AGV接口调用失败: " + e.getMessage());
            throw new ServiceException("下发AGV任务失败: " + e.getMessage());
        }
    }

    /**
     * 下发出库任务到AGV
     *
     * @param palletCode 托盘编号
     * @param fromBinCode 起始货位
     * @param toBinCode 目标货位（通常是出库口）
     * @param bizOrderNo 业务单号
     * @param bizOrderId 业务单ID
     * @return AGV任务ID
     */
    @Transactional(rollbackFor = Exception.class)
    public String dispatchOutboundTask(String palletCode, String fromBinCode, String toBinCode,
                                       String bizOrderNo, Long bizOrderId) {
        // 创建AGV任务记录
        AgvTaskBo taskBo = new AgvTaskBo();
        taskBo.setTaskType(4); // 出库任务
        taskBo.setPalletCode(palletCode);
        taskBo.setFromBinCode(fromBinCode);
        taskBo.setToBinCode(toBinCode);
        taskBo.setBizOrderNo(bizOrderNo);
        taskBo.setBizOrderId(bizOrderId);
        agvTaskService.insertByBo(taskBo);

        AgvTaskVo task = agvTaskService.queryByTaskNo(taskBo.getTaskNo());

        // 调用AGV接口
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("outID", task.getTaskNo());
        requestBody.put("palletCode", palletCode);
        requestBody.put("fromBinCode", fromBinCode);
        requestBody.put("toBinCode", toBinCode);
        requestBody.put("taskType", "OUTBOUND");

        try {
            String agvTaskId = callAgvApi("/task/dispatch", requestBody);
            
            // 更新任务记录
            AgvTaskBo updateBo = new AgvTaskBo();
            updateBo.setId(task.getId());
            updateBo.setAgvTaskId(agvTaskId);
            updateBo.setStatus(1); // EXECUTING
            agvTaskService.updateByBo(updateBo);

            return agvTaskId;
        } catch (Exception e) {
            log.error("下发出库任务失败", e);
            agvTaskService.updateTaskStatusByTaskNo(task.getTaskNo(), 3, "AGV接口调用失败: " + e.getMessage());
            throw new ServiceException("下发AGV任务失败: " + e.getMessage());
        }
    }

    /**
     * 下发送检任务到AGV
     *
     * @param palletCode 托盘编号
     * @param fromBinCode 起始货位
     * @param toBinCode 目标货位（检测区）
     * @return AGV任务ID
     */
    @Transactional(rollbackFor = Exception.class)
    public String dispatchInspectionTask(String palletCode, String fromBinCode, String toBinCode) {
        AgvTaskBo taskBo = new AgvTaskBo();
        taskBo.setTaskType(2); // 送检任务
        taskBo.setPalletCode(palletCode);
        taskBo.setFromBinCode(fromBinCode);
        taskBo.setToBinCode(toBinCode);
        agvTaskService.insertByBo(taskBo);

        AgvTaskVo task = agvTaskService.queryByTaskNo(taskBo.getTaskNo());

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("outID", task.getTaskNo());
        requestBody.put("palletCode", palletCode);
        requestBody.put("fromBinCode", fromBinCode);
        requestBody.put("toBinCode", toBinCode);
        requestBody.put("taskType", "INSPECTION");

        try {
            String agvTaskId = callAgvApi("/task/dispatch", requestBody);
            
            AgvTaskBo updateBo = new AgvTaskBo();
            updateBo.setId(task.getId());
            updateBo.setAgvTaskId(agvTaskId);
            updateBo.setStatus(1);
            agvTaskService.updateByBo(updateBo);

            return agvTaskId;
        } catch (Exception e) {
            log.error("下发送检任务失败", e);
            agvTaskService.updateTaskStatusByTaskNo(task.getTaskNo(), 3, "AGV接口调用失败: " + e.getMessage());
            throw new ServiceException("下发AGV任务失败: " + e.getMessage());
        }
    }

    /**
     * 下发回库任务到AGV
     *
     * @param palletCode 托盘编号
     * @param fromBinCode 起始货位（检测区）
     * @param toBinCode 目标货位（仓库货位）
     * @return AGV任务ID
     */
    @Transactional(rollbackFor = Exception.class)
    public String dispatchReturnTask(String palletCode, String fromBinCode, String toBinCode) {
        AgvTaskBo taskBo = new AgvTaskBo();
        taskBo.setTaskType(3); // 回库任务
        taskBo.setPalletCode(palletCode);
        taskBo.setFromBinCode(fromBinCode);
        taskBo.setToBinCode(toBinCode);
        agvTaskService.insertByBo(taskBo);

        AgvTaskVo task = agvTaskService.queryByTaskNo(taskBo.getTaskNo());

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("outID", task.getTaskNo());
        requestBody.put("palletCode", palletCode);
        requestBody.put("fromBinCode", fromBinCode);
        requestBody.put("toBinCode", toBinCode);
        requestBody.put("taskType", "RETURN");

        try {
            String agvTaskId = callAgvApi("/task/dispatch", requestBody);
            
            AgvTaskBo updateBo = new AgvTaskBo();
            updateBo.setId(task.getId());
            updateBo.setAgvTaskId(agvTaskId);
            updateBo.setStatus(1);
            agvTaskService.updateByBo(updateBo);

            return agvTaskId;
        } catch (Exception e) {
            log.error("下发回库任务失败", e);
            agvTaskService.updateTaskStatusByTaskNo(task.getTaskNo(), 3, "AGV接口调用失败: " + e.getMessage());
            throw new ServiceException("下发AGV任务失败: " + e.getMessage());
        }
    }

    /**
     * 取消AGV任务
     *
     * @param agvTaskId AGV任务ID
     */
    @Transactional(rollbackFor = Exception.class)
    public void cancelAgvTask(String agvTaskId) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("taskId", agvTaskId);

        try {
            callAgvApi("/task/cancel", requestBody);
            
            // 更新本地任务状态
            AgvTaskVo task = agvTaskService.queryByTaskNo(agvTaskId);
            if (task != null) {
                agvTaskService.cancelTask(task.getId());
            }
        } catch (Exception e) {
            log.error("取消AGV任务失败", e);
            throw new ServiceException("取消AGV任务失败: " + e.getMessage());
        }
    }

    /**
     * 同步托盘状态
     *
     * @param palletCode 托盘编号
     * @return 托盘当前状态信息
     */
    public Map<String, Object> syncPalletStatus(String palletCode) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("palletCode", palletCode);

        try {
            return callAgvApiForMap("/pallet/status", requestBody);
        } catch (Exception e) {
            log.error("同步托盘状态失败", e);
            throw new ServiceException("同步托盘状态失败: " + e.getMessage());
        }
    }

    /**
     * 调用AGV API
     */
    private String callAgvApi(String endpoint, Map<String, Object> requestBody) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        if (StrUtil.isNotBlank(agvApiKey)) {
            headers.set("X-API-Key", agvApiKey);
        }
        if (StrUtil.isNotBlank(agvApiToken)) {
            headers.set("Authorization", "Bearer " + agvApiToken);
        }

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        String url = agvApiUrl + endpoint;

        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                Map<String, Object> body = response.getBody();
                return (String) body.get("taskId");
            }
            throw new ServiceException("AGV接口返回错误");
        } catch (Exception e) {
            log.error("调用AGV接口失败: {}", url, e);
            throw new ServiceException("调用AGV接口失败: " + e.getMessage());
        }
    }

    /**
     * 调用AGV API并返回Map
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> callAgvApiForMap(String endpoint, Map<String, Object> requestBody) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        if (StrUtil.isNotBlank(agvApiKey)) {
            headers.set("X-API-Key", agvApiKey);
        }
        if (StrUtil.isNotBlank(agvApiToken)) {
            headers.set("Authorization", "Bearer " + agvApiToken);
        }

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        String url = agvApiUrl + endpoint;

        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                return response.getBody();
            }
            throw new ServiceException("AGV接口返回错误");
        } catch (Exception e) {
            log.error("调用AGV接口失败: {}", url, e);
            throw new ServiceException("调用AGV接口失败: " + e.getMessage());
        }
    }
}

