package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

/**
 * PDA阀门查询请求DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaValveQueryRequest {

    /**
     * 厂家名称（模糊查询）
     */
    private String vendorName;

    /**
     * 阀门编号（精确查询）
     */
    private String valveNo;

    /**
     * 阀门型号（模糊查询）
     */
    private String valveModel;

    /**
     * 入库日期（yyyy-MM-dd格式）
     */
    private String inboundDate;

    /**
     * 阀门状态（IN_STOCK、IN_INSPECTION、INSPECTED、OUTBOUND）
     */
    private String valveStatus;

    /**
     * 页码，默认1
     */
    private Integer pageNum = 1;

    /**
     * 每页大小，默认20
     */
    private Integer pageSize = 20;
}

