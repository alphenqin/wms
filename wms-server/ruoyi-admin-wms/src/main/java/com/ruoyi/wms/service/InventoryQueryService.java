package com.ruoyi.wms.service;

import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.vo.InventoryVo;
import com.ruoyi.wms.domain.vo.ValveVo;
import com.ruoyi.wms.domain.vo.PalletVo;
import com.ruoyi.wms.domain.vo.BinVo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 库存查询Service
 * 提供增强的库存查询功能
 *
 * @author wms
 * @date 2024
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class InventoryQueryService {

    private final InventoryService inventoryService;
    private final InventoryHistoryService inventoryHistoryService;
    private final ValveService valveService;
    private final PalletService palletService;
    private final BinService binService;

    /**
     * 按日期查询库存
     */
    public List<InventoryVo> queryByDate(Date startDate, Date endDate, Long warehouseId) {
        // 通过库存历史记录查询
        var bo = new com.ruoyi.wms.domain.bo.InventoryHistoryBo();
        bo.setWarehouseId(warehouseId);
        var historyList = inventoryHistoryService.queryList(bo);
        
        // 根据历史记录汇总当前库存
        // 这里简化处理，实际应该根据历史记录计算
        var inventoryBo = new com.ruoyi.wms.domain.bo.InventoryBo();
        inventoryBo.setWarehouseId(warehouseId);
        return inventoryService.queryList(inventoryBo);
    }

    /**
     * 按批次查询库存
     */
    public List<ValveVo> queryByBatch(String batchNo, Long warehouseId) {
        var bo = new com.ruoyi.wms.domain.bo.ValveBo();
        bo.setBatchNo(batchNo);
        if (warehouseId != null) {
            // 可以通过货位关联查询仓库
        }
        return valveService.queryList(bo);
    }

    /**
     * 按物料查询库存
     */
    public List<InventoryVo> queryByMaterial(Long itemId, Long warehouseId) {
        var bo = new com.ruoyi.wms.domain.bo.InventoryBo();
        bo.setWarehouseId(warehouseId);
        // 需要通过sku关联item查询
        var list = inventoryService.queryList(bo);
        // 过滤出指定物料的库存
        return list.stream()
            .filter(inv -> {
                // 这里需要通过ItemSku关联Item进行过滤
                // 简化处理，实际需要关联查询
                return true;
            })
            .toList();
    }

    /**
     * 按阀门型号查询
     */
    public List<ValveVo> queryByValveModel(String model, Long warehouseId) {
        var bo = new com.ruoyi.wms.domain.bo.ValveBo();
        bo.setModel(model);
        return valveService.queryList(bo);
    }

    /**
     * 按库位查询库存
     */
    public List<ValveVo> queryByBin(String binCode) {
        var binVo = binService.queryByBinCode(binCode);
        if (binVo == null) {
            return List.of();
        }
        var bo = new com.ruoyi.wms.domain.bo.ValveBo();
        bo.setCurrentBinId(binVo.getId());
        return valveService.queryList(bo);
    }

    /**
     * 按托盘查询库存
     */
    public List<ValveVo> queryByPallet(String palletCode) {
        var palletVo = palletService.queryByPalletCode(palletCode);
        if (palletVo == null) {
            return List.of();
        }
        var bo = new com.ruoyi.wms.domain.bo.ValveBo();
        bo.setPalletId(palletVo.getId());
        return valveService.queryList(bo);
    }

    /**
     * 综合查询库存（支持多条件）
     */
    public TableDataInfo<Map<String, Object>> queryInventoryComprehensive(
            Date startDate, Date endDate, String batchNo, Long itemId,
            String model, String binCode, String palletCode, Long warehouseId,
            PageQuery pageQuery) {
        // 综合查询逻辑
        // 这里可以根据实际需求实现复杂的关联查询
        // 简化实现，返回空结果
        return TableDataInfo.build();
    }

    /**
     * 查询库存状态统计
     */
    public Map<String, Object> queryInventoryStatusSummary(Long warehouseId) {
        // 统计阀门状态
        long valveInStock = valveService.queryByStatus(0).size(); // 在库
        long valveInspecting = valveService.queryByStatus(1).size(); // 检测中
        long valveInspected = valveService.queryByStatus(2).size(); // 已检测
        long valveShipped = valveService.queryByStatus(3).size(); // 已出库

        // 统计托盘状态
        var palletBo = new com.ruoyi.wms.domain.bo.PalletBo();
        palletBo.setIsEmpty(1);
        long emptyPallets = palletService.queryList(palletBo).size();
        palletBo.setIsEmpty(0);
        long loadedPallets = palletService.queryList(palletBo).size();

        // 统计货位状态
        var binBo = new com.ruoyi.wms.domain.bo.BinBo();
        binBo.setStatus(0);
        long emptyBins = binService.queryList(binBo).size();
        binBo.setStatus(1);
        long occupiedBins = binService.queryList(binBo).size();
        binBo.setStatus(2);
        long disabledBins = binService.queryList(binBo).size();
        binBo.setStatus(3);
        long lockedBins = binService.queryList(binBo).size();

        return Map.of(
            "valveInStock", valveInStock,
            "valveInspecting", valveInspecting,
            "valveInspected", valveInspected,
            "valveShipped", valveShipped,
            "emptyPallets", emptyPallets,
            "loadedPallets", loadedPallets,
            "emptyBins", emptyBins,
            "occupiedBins", occupiedBins,
            "disabledBins", disabledBins,
            "lockedBins", lockedBins
        );
    }
}

