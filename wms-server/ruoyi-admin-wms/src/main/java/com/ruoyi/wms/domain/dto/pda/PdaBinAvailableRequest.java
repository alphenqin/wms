package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

/**
 * PDA获取可用库位请求DTO
 *
 * @author wms
 * @date 2025-12-22
 */
@Data
public class PdaBinAvailableRequest {

    /**
     * 仓库ID（可选）
     */
    private Long warehouseId;

    /**
     * 货区ID（可选）
     */
    private Long areaId;

    /**
     * 托盘类型（t1/SMALL 或 t2/LARGE，可选）
     */
    private String palletType;

    /**
     * 库外站点（可用于推断托盘类型，可选）
     */
    private String outsideSite;

    /**
     * 是否只选择一层库位；false 表示选择二/三层库位
     */
    private Boolean firstFloor;
}
