package com.ruoyi.wms.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.log.annotation.Log;
import com.ruoyi.common.log.enums.BusinessType;
import com.ruoyi.common.web.core.BaseController;
import com.ruoyi.wms.service.AgvIntegrationService;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * AGV集成接口Controller
 * 提供与AGV调度系统对接的接口
 *
 * @author wms
 * @date 2024
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/agv")
public class AgvIntegrationController extends BaseController {

    private final AgvIntegrationService agvIntegrationService;

    /**
     * 下发入库任务
     */
    @SaCheckPermission("wms:agv:dispatch")
    @Log(title = "AGV任务", businessType = BusinessType.OTHER)
    @PostMapping("/dispatch/inbound")
    public R<String> dispatchInboundTask(@RequestParam String palletCode,
                                         @RequestParam String fromBinCode,
                                         @RequestParam String toBinCode,
                                         @RequestParam(required = false) String bizOrderNo,
                                         @RequestParam(required = false) Long bizOrderId) {
        String agvTaskId = agvIntegrationService.dispatchInboundTask(
            palletCode, fromBinCode, toBinCode, bizOrderNo, bizOrderId);
        return R.ok(agvTaskId);
    }

    /**
     * 下发出库任务
     */
    @SaCheckPermission("wms:agv:dispatch")
    @Log(title = "AGV任务", businessType = BusinessType.OTHER)
    @PostMapping("/dispatch/outbound")
    public R<String> dispatchOutboundTask(@RequestParam String palletCode,
                                          @RequestParam String fromBinCode,
                                          @RequestParam String toBinCode,
                                          @RequestParam(required = false) String bizOrderNo,
                                          @RequestParam(required = false) Long bizOrderId) {
        String agvTaskId = agvIntegrationService.dispatchOutboundTask(
            palletCode, fromBinCode, toBinCode, bizOrderNo, bizOrderId);
        return R.ok(agvTaskId);
    }

    /**
     * 下发送检任务
     */
    @SaCheckPermission("wms:agv:dispatch")
    @Log(title = "AGV任务", businessType = BusinessType.OTHER)
    @PostMapping("/dispatch/inspection")
    public R<String> dispatchInspectionTask(@RequestParam String palletCode,
                                             @RequestParam String fromBinCode,
                                             @RequestParam String toBinCode) {
        String agvTaskId = agvIntegrationService.dispatchInspectionTask(
            palletCode, fromBinCode, toBinCode);
        return R.ok(agvTaskId);
    }

    /**
     * 下发回库任务
     */
    @SaCheckPermission("wms:agv:dispatch")
    @Log(title = "AGV任务", businessType = BusinessType.OTHER)
    @PostMapping("/dispatch/return")
    public R<String> dispatchReturnTask(@RequestParam String palletCode,
                                        @RequestParam String fromBinCode,
                                        @RequestParam String toBinCode) {
        String agvTaskId = agvIntegrationService.dispatchReturnTask(
            palletCode, fromBinCode, toBinCode);
        return R.ok(agvTaskId);
    }

    /**
     * 取消AGV任务
     */
    @SaCheckPermission("wms:agv:dispatch")
    @Log(title = "AGV任务", businessType = BusinessType.OTHER)
    @PostMapping("/cancel")
    public R<Void> cancelTask(@RequestParam String agvTaskId) {
        agvIntegrationService.cancelAgvTask(agvTaskId);
        return R.ok();
    }

    /**
     * 同步托盘状态
     */
    @SaCheckPermission("wms:agv:sync")
    @Log(title = "AGV同步", businessType = BusinessType.OTHER)
    @GetMapping("/sync/pallet")
    public R<Map<String, Object>> syncPalletStatus(@RequestParam String palletCode) {
        Map<String, Object> status = agvIntegrationService.syncPalletStatus(palletCode);
        return R.ok(status);
    }
}

