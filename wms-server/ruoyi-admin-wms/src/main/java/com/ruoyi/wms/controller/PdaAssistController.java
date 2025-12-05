package com.ruoyi.wms.controller;

import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.log.annotation.Log;
import com.ruoyi.common.log.enums.BusinessType;
import com.ruoyi.common.web.core.BaseController;
import com.ruoyi.wms.domain.bo.PdaOperationBo;
import com.ruoyi.wms.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * PDA辅助操作Controller
 * 提供PDA设备调用的接口
 *
 * @author wms
 * @date 2024
 */
@Slf4j
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/pda/assist")
public class PdaAssistController extends BaseController {

    private final BarcodeService barcodeService;
    private final PalletService palletService;
    private final ValveService valveService;
    private final BinService binService;
    private final AgvTaskService agvTaskService;
    private final PdaOperationService pdaOperationService;

    /**
     * 托盘扫码
     */
    @Log(title = "PDA操作", businessType = BusinessType.OTHER)
    @PostMapping("/scan/pallet")
    public R<Map<String, Object>> scanPallet(@RequestParam String barcode,
                                              @RequestParam String pdaDeviceNo,
                                              @RequestParam String operator) {
        try {
            // 查询条码信息
            var barcodeVo = barcodeService.queryByBarcode(barcode);
            if (barcodeVo == null) {
                return R.fail("条码不存在");
            }

            // 查询托盘信息
            var palletVo = palletService.queryByPalletCode(barcodeVo.getObjectCode());
            if (palletVo == null) {
                return R.fail("托盘不存在");
            }

            // 记录操作
            recordOperation(1, operator, pdaDeviceNo, barcode, null, null, 1, "托盘扫码成功", null);

            Map<String, Object> result = new HashMap<>();
            result.put("palletCode", palletVo.getPalletCode());
            result.put("palletType", palletVo.getPalletTypeName());
            result.put("currentBinCode", palletVo.getCurrentBinCode());
            result.put("isEmpty", palletVo.getIsEmpty());
            result.put("isBound", palletVo.getIsBound());
            return R.ok(result);
        } catch (Exception e) {
            log.error("托盘扫码失败", e);
            recordOperation(1, operator, pdaDeviceNo, barcode, null, null, 0, null, e.getMessage());
            return R.fail("托盘扫码失败: " + e.getMessage());
        }
    }

    /**
     * 阀门扫码
     */
    @Log(title = "PDA操作", businessType = BusinessType.OTHER)
    @PostMapping("/scan/valve")
    public R<Map<String, Object>> scanValve(@RequestParam String barcode,
                                            @RequestParam String pdaDeviceNo,
                                            @RequestParam String operator) {
        try {
            var barcodeVo = barcodeService.queryByBarcode(barcode);
            if (barcodeVo == null) {
                return R.fail("条码不存在");
            }

            var valveVo = valveService.queryByValveNo(barcodeVo.getObjectCode());
            if (valveVo == null) {
                return R.fail("阀门不存在");
            }

            recordOperation(2, operator, pdaDeviceNo, barcode, null, null, 1, "阀门扫码成功", null);

            Map<String, Object> result = new HashMap<>();
            result.put("valveNo", valveVo.getValveNo());
            result.put("model", valveVo.getModel());
            result.put("manufacturer", valveVo.getManufacturer());
            result.put("status", valveVo.getStatus());
            result.put("palletCode", valveVo.getPalletCode());
            result.put("currentBinCode", valveVo.getCurrentBinCode());
            return R.ok(result);
        } catch (Exception e) {
            log.error("阀门扫码失败", e);
            recordOperation(2, operator, pdaDeviceNo, barcode, null, null, 0, null, e.getMessage());
            return R.fail("阀门扫码失败: " + e.getMessage());
        }
    }

    /**
     * 库位扫码
     */
    @Log(title = "PDA操作", businessType = BusinessType.OTHER)
    @PostMapping("/scan/bin")
    public R<Map<String, Object>> scanBin(@RequestParam String barcode,
                                          @RequestParam String pdaDeviceNo,
                                          @RequestParam String operator) {
        try {
            var barcodeVo = barcodeService.queryByBarcode(barcode);
            if (barcodeVo == null) {
                return R.fail("条码不存在");
            }

            var binVo = binService.queryByBinCode(barcodeVo.getObjectCode());
            if (binVo == null) {
                return R.fail("货位不存在");
            }

            recordOperation(3, operator, pdaDeviceNo, barcode, null, null, 1, "库位扫码成功", null);

            Map<String, Object> result = new HashMap<>();
            result.put("binCode", binVo.getBinCode());
            result.put("binName", binVo.getBinName());
            result.put("status", binVo.getStatus());
            result.put("capacity", binVo.getCapacity());
            result.put("usedCapacity", binVo.getUsedCapacity());
            return R.ok(result);
        } catch (Exception e) {
            log.error("库位扫码失败", e);
            recordOperation(3, operator, pdaDeviceNo, barcode, null, null, 0, null, e.getMessage());
            return R.fail("库位扫码失败: " + e.getMessage());
        }
    }

    /**
     * 取消任务
     */
    @Log(title = "PDA操作", businessType = BusinessType.OTHER)
    @PostMapping("/cancel/task")
    public R<Void> cancelTask(@RequestParam String taskNo,
                              @RequestParam String pdaDeviceNo,
                              @RequestParam String operator) {
        try {
            var taskVo = agvTaskService.queryByTaskNo(taskNo);
            if (taskVo == null) {
                return R.fail("任务不存在");
            }

            agvTaskService.cancelTask(taskVo.getId());
            recordOperation(9, operator, pdaDeviceNo, taskNo, taskVo.getBizOrderNo(), taskVo.getBizOrderId(), 1, "任务取消成功", null);
            return R.ok();
        } catch (Exception e) {
            log.error("取消任务失败", e);
            recordOperation(9, operator, pdaDeviceNo, taskNo, null, null, 0, null, e.getMessage());
            return R.fail("取消任务失败: " + e.getMessage());
        }
    }

    /**
     * 记录PDA操作
     */
    private void recordOperation(Integer operationType, String operator, String pdaDeviceNo,
                                 String scannedCode, String bizOrderNo, Long bizOrderId,
                                 Integer result, String resultMsg, String errorMsg) {
        try {
            PdaOperationBo bo = new PdaOperationBo();
            bo.setOperationType(operationType);
            bo.setOperator(operator);
            bo.setPdaDeviceNo(pdaDeviceNo);
            bo.setScannedCode(scannedCode);
            bo.setBizOrderNo(bizOrderNo);
            bo.setBizOrderId(bizOrderId);
            bo.setResult(result);
            bo.setResultMsg(resultMsg);
            bo.setErrorMsg(errorMsg);
            pdaOperationService.insertByBo(bo);
        } catch (Exception e) {
            log.error("记录PDA操作失败", e);
        }
    }
}

