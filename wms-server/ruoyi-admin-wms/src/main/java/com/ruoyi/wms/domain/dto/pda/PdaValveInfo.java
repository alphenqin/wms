package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * PDA阀门信息DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaValveInfo implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 阀门唯一编号
     */
    private String valveNo;

    /**
     * 物料编码
     */
    private String matCode;

    /**
     * 厂家名称
     */
    private String vendorName;

    /**
     * 入库日期（yyyy-MM-dd格式）
     */
    private String inboundDate;

    /**
     * 托盘号
     */
    private String palletNo;

    /**
     * 送检日期
     */
    private String inspectionDate;

    /**
     * 回库日期
     */
    private String returnDate;

    /**
     * 库位号
     */
    private String binCode;

    /**
     * 阀门状态（IN_STOCK、IN_INSPECTION、INSPECTED、OUTBOUND）
     */
    private String valveStatus;

    /**
     * 送检目标站点（如 Z6-装卸点/Z7-装卸点）
     */
    private String inspectionTargetBin;

    /**
     * 备注
     */
    private String remark;
}

