package com.ruoyi.wms.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.excel.utils.ExcelUtil;
import com.ruoyi.common.log.annotation.Log;
import com.ruoyi.common.log.enums.BusinessType;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.common.web.core.BaseController;
import com.ruoyi.wms.service.ReportService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.Map;

/**
 * 报表Controller
 * 提供各种报表查询接口
 *
 * @author wms
 * @date 2024
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/report")
public class ReportController extends BaseController {

    private final ReportService reportService;

    /**
     * 入库报表
     */
    @SaCheckPermission("wms:report:list")
    @GetMapping("/inbound")
    public TableDataInfo<Map<String, Object>> queryInboundReport(
            @RequestParam(required = false) Date startDate,
            @RequestParam(required = false) Date endDate,
            @RequestParam(required = false) String model,
            @RequestParam(required = false) String manufacturer,
            @RequestParam(required = false) Long warehouseId,
            PageQuery pageQuery) {
        return reportService.queryInboundReport(startDate, endDate, model, manufacturer, warehouseId, pageQuery);
    }

    /**
     * 入库统计汇总
     */
    @SaCheckPermission("wms:report:list")
    @GetMapping("/inbound/summary")
    public R<Map<String, Object>> queryInboundSummary(
            @RequestParam(required = false) Date startDate,
            @RequestParam(required = false) Date endDate,
            @RequestParam(required = false) Long warehouseId) {
        return R.ok(reportService.queryInboundSummary(startDate, endDate, warehouseId));
    }

    /**
     * 出库报表
     */
    @SaCheckPermission("wms:report:list")
    @GetMapping("/outbound")
    public TableDataInfo<Map<String, Object>> queryOutboundReport(
            @RequestParam(required = false) Date startDate,
            @RequestParam(required = false) Date endDate,
            @RequestParam(required = false) String model,
            @RequestParam(required = false) String manufacturer,
            @RequestParam(required = false) Long warehouseId,
            PageQuery pageQuery) {
        return reportService.queryOutboundReport(startDate, endDate, model, manufacturer, warehouseId, pageQuery);
    }

    /**
     * 出库统计汇总
     */
    @SaCheckPermission("wms:report:list")
    @GetMapping("/outbound/summary")
    public R<Map<String, Object>> queryOutboundSummary(
            @RequestParam(required = false) Date startDate,
            @RequestParam(required = false) Date endDate,
            @RequestParam(required = false) Long warehouseId) {
        return R.ok(reportService.queryOutboundSummary(startDate, endDate, warehouseId));
    }

    /**
     * 盘存报表
     */
    @SaCheckPermission("wms:report:list")
    @GetMapping("/check")
    public TableDataInfo<Map<String, Object>> queryCheckReport(
            @RequestParam(required = false) Date startDate,
            @RequestParam(required = false) Date endDate,
            @RequestParam(required = false) Long warehouseId,
            PageQuery pageQuery) {
        return reportService.queryCheckReport(startDate, endDate, warehouseId, pageQuery);
    }

    /**
     * 库存统计表
     */
    @SaCheckPermission("wms:report:list")
    @GetMapping("/inventory")
    public TableDataInfo<Map<String, Object>> queryInventoryStatistics(
            @RequestParam(required = false) Long warehouseId,
            @RequestParam(required = false) Long itemId,
            @RequestParam(required = false) String model,
            PageQuery pageQuery) {
        return reportService.queryInventoryStatistics(warehouseId, itemId, model, pageQuery);
    }
}

