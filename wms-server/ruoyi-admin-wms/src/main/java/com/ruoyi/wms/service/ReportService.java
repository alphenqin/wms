package com.ruoyi.wms.service;

import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.vo.ReceiptOrderVo;
import com.ruoyi.wms.domain.vo.ShipmentOrderVo;
import com.ruoyi.wms.domain.vo.CheckOrderVo;
import com.ruoyi.wms.domain.vo.InventoryVo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 报表Service
 * 提供各种报表查询功能
 *
 * @author wms
 * @date 2024
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class ReportService {

    private final ReceiptOrderService receiptOrderService;
    private final ShipmentOrderService shipmentOrderService;
    private final CheckOrderService checkOrderService;
    private final InventoryService inventoryService;
    private final InventoryQueryService inventoryQueryService;

    /**
     * 入库报表
     * 按日期、型号、厂家统计
     */
    public TableDataInfo<Map<String, Object>> queryInboundReport(LocalDateTime startDate, LocalDateTime endDate,
                                                                  String model, String manufacturer,
                                                                  Long warehouseId, PageQuery pageQuery) {
        // 查询入库单
        var bo = new com.ruoyi.wms.domain.bo.ReceiptOrderBo();
        bo.setWarehouseId(warehouseId);
        var receiptOrders = receiptOrderService.queryList(bo);
        
        // 按日期过滤
        if (startDate != null || endDate != null) {
            receiptOrders = receiptOrders.stream()
                .filter(order -> {
                    LocalDateTime createTime = order.getCreateTime();
                    if (createTime == null) return false;
                    if (startDate != null && createTime.isBefore(startDate)) return false;
                    if (endDate != null && createTime.isAfter(endDate)) return false;
                    return true;
                })
                .toList();
        }

        // 统计逻辑
        // 这里简化实现，实际应该根据明细进行统计
        return TableDataInfo.build();
    }

    /**
     * 出库报表
     */
    public TableDataInfo<Map<String, Object>> queryOutboundReport(LocalDateTime startDate, LocalDateTime endDate,
                                                                   String model, String manufacturer,
                                                                   Long warehouseId, PageQuery pageQuery) {
        // 查询出库单
        var bo = new com.ruoyi.wms.domain.bo.ShipmentOrderBo();
        bo.setWarehouseId(warehouseId);
        var shipmentOrders = shipmentOrderService.queryList(bo);
        
        // 按日期过滤
        if (startDate != null || endDate != null) {
            shipmentOrders = shipmentOrders.stream()
                .filter(order -> {
                    LocalDateTime createTime = order.getCreateTime();
                    if (createTime == null) return false;
                    if (startDate != null && createTime.isBefore(startDate)) return false;
                    if (endDate != null && createTime.isAfter(endDate)) return false;
                    return true;
                })
                .toList();
        }

        // 统计逻辑
        return TableDataInfo.build();
    }

    /**
     * 盘存报表
     */
    public TableDataInfo<Map<String, Object>> queryCheckReport(LocalDateTime startDate, LocalDateTime endDate,
                                                               Long warehouseId, PageQuery pageQuery) {
        // 查询盘点单
        var bo = new com.ruoyi.wms.domain.bo.CheckOrderBo();
        bo.setWarehouseId(warehouseId);
        var checkOrders = checkOrderService.queryList(bo);
        
        // 按日期过滤
        if (startDate != null || endDate != null) {
            checkOrders = checkOrders.stream()
                .filter(order -> {
                    LocalDateTime createTime = order.getCreateTime();
                    if (createTime == null) return false;
                    if (startDate != null && createTime.isBefore(startDate)) return false;
                    if (endDate != null && createTime.isAfter(endDate)) return false;
                    return true;
                })
                .toList();
        }

        // 统计逻辑
        return TableDataInfo.build();
    }

    /**
     * 库存统计表
     */
    public TableDataInfo<Map<String, Object>> queryInventoryStatistics(Long warehouseId,
                                                                        Long itemId,
                                                                        String model,
                                                                        PageQuery pageQuery) {
        // 查询库存
        var bo = new com.ruoyi.wms.domain.bo.InventoryBo();
        bo.setWarehouseId(warehouseId);
        var inventoryList = inventoryService.queryList(bo);
        
        // 统计逻辑
        // 按物料、型号等维度统计
        return TableDataInfo.build();
    }

    /**
     * 入库统计汇总
     */
    public Map<String, Object> queryInboundSummary(LocalDateTime startDate, LocalDateTime endDate, Long warehouseId) {
        var bo = new com.ruoyi.wms.domain.bo.ReceiptOrderBo();
        bo.setWarehouseId(warehouseId);
        var orders = receiptOrderService.queryList(bo);
        
        // 按日期过滤
        if (startDate != null || endDate != null) {
            orders = orders.stream()
                .filter(order -> {
                    LocalDateTime createTime = order.getCreateTime();
                    if (createTime == null) return false;
                    if (startDate != null && createTime.isBefore(startDate)) return false;
                    if (endDate != null && createTime.isAfter(endDate)) return false;
                    return true;
                })
                .toList();
        }

        // 统计汇总
        long totalCount = orders.size();
        double totalQuantity = orders.stream()
            .mapToDouble(order -> order.getTotalQuantity() != null ? order.getTotalQuantity().doubleValue() : 0)
            .sum();
        double totalAmount = orders.stream()
            .mapToDouble(order -> order.getTotalAmount() != null ? order.getTotalAmount().doubleValue() : 0)
            .sum();

        return Map.of(
            "totalCount", totalCount,
            "totalQuantity", totalQuantity,
            "totalAmount", totalAmount
        );
    }

    /**
     * 出库统计汇总
     */
    public Map<String, Object> queryOutboundSummary(LocalDateTime startDate, LocalDateTime endDate, Long warehouseId) {
        var bo = new com.ruoyi.wms.domain.bo.ShipmentOrderBo();
        bo.setWarehouseId(warehouseId);
        var orders = shipmentOrderService.queryList(bo);
        
        // 按日期过滤
        if (startDate != null || endDate != null) {
            orders = orders.stream()
                .filter(order -> {
                    LocalDateTime createTime = order.getCreateTime();
                    if (createTime == null) return false;
                    if (startDate != null && createTime.isBefore(startDate)) return false;
                    if (endDate != null && createTime.isAfter(endDate)) return false;
                    return true;
                })
                .toList();
        }

        // 统计汇总
        long totalCount = orders.size();
        double totalQuantity = orders.stream()
            .mapToDouble(order -> order.getTotalQuantity() != null ? order.getTotalQuantity().doubleValue() : 0)
            .sum();
        double totalAmount = orders.stream()
            .mapToDouble(order -> order.getTotalAmount() != null ? order.getTotalAmount().doubleValue() : 0)
            .sum();

        return Map.of(
            "totalCount", totalCount,
            "totalQuantity", totalQuantity,
            "totalAmount", totalAmount
        );
    }
}

