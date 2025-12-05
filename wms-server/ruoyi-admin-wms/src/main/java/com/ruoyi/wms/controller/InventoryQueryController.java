package com.ruoyi.wms.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.common.web.core.BaseController;
import com.ruoyi.wms.domain.vo.InventoryVo;
import com.ruoyi.wms.domain.vo.ValveVo;
import com.ruoyi.wms.service.InventoryQueryService;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 库存查询Controller
 * 提供增强的库存查询接口
 *
 * @author wms
 * @date 2024
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/inventory/query")
public class InventoryQueryController extends BaseController {

    private final InventoryQueryService inventoryQueryService;

    /**
     * 按日期查询库存
     */
    @SaCheckPermission("wms:inventory:list")
    @GetMapping("/byDate")
    public R<List<InventoryVo>> queryByDate(@RequestParam(required = false) Date startDate,
                                             @RequestParam(required = false) Date endDate,
                                             @RequestParam(required = false) Long warehouseId) {
        return R.ok(inventoryQueryService.queryByDate(startDate, endDate, warehouseId));
    }

    /**
     * 按批次查询库存
     */
    @SaCheckPermission("wms:inventory:list")
    @GetMapping("/byBatch")
    public R<List<ValveVo>> queryByBatch(@RequestParam String batchNo,
                                         @RequestParam(required = false) Long warehouseId) {
        return R.ok(inventoryQueryService.queryByBatch(batchNo, warehouseId));
    }

    /**
     * 按物料查询库存
     */
    @SaCheckPermission("wms:inventory:list")
    @GetMapping("/byMaterial")
    public R<List<InventoryVo>> queryByMaterial(@RequestParam Long itemId,
                                                 @RequestParam(required = false) Long warehouseId) {
        return R.ok(inventoryQueryService.queryByMaterial(itemId, warehouseId));
    }

    /**
     * 按阀门型号查询
     */
    @SaCheckPermission("wms:inventory:list")
    @GetMapping("/byValveModel")
    public R<List<ValveVo>> queryByValveModel(@RequestParam String model,
                                              @RequestParam(required = false) Long warehouseId) {
        return R.ok(inventoryQueryService.queryByValveModel(model, warehouseId));
    }

    /**
     * 按库位查询库存
     */
    @SaCheckPermission("wms:inventory:list")
    @GetMapping("/byBin")
    public R<List<ValveVo>> queryByBin(@RequestParam String binCode) {
        return R.ok(inventoryQueryService.queryByBin(binCode));
    }

    /**
     * 按托盘查询库存
     */
    @SaCheckPermission("wms:inventory:list")
    @GetMapping("/byPallet")
    public R<List<ValveVo>> queryByPallet(@RequestParam String palletCode) {
        return R.ok(inventoryQueryService.queryByPallet(palletCode));
    }

    /**
     * 综合查询库存
     */
    @SaCheckPermission("wms:inventory:list")
    @GetMapping("/comprehensive")
    public TableDataInfo<Map<String, Object>> queryComprehensive(
            @RequestParam(required = false) Date startDate,
            @RequestParam(required = false) Date endDate,
            @RequestParam(required = false) String batchNo,
            @RequestParam(required = false) Long itemId,
            @RequestParam(required = false) String model,
            @RequestParam(required = false) String binCode,
            @RequestParam(required = false) String palletCode,
            @RequestParam(required = false) Long warehouseId,
            PageQuery pageQuery) {
        return inventoryQueryService.queryInventoryComprehensive(
            startDate, endDate, batchNo, itemId, model, binCode, palletCode, warehouseId, pageQuery);
    }

    /**
     * 查询库存状态统计
     */
    @SaCheckPermission("wms:inventory:list")
    @GetMapping("/statusSummary")
    public R<Map<String, Object>> queryStatusSummary(@RequestParam(required = false) Long warehouseId) {
        return R.ok(inventoryQueryService.queryInventoryStatusSummary(warehouseId));
    }
}

