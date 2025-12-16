package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

/**
 * PDA任务查询请求DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaTaskQueryRequest {

    /**
     * 起始日期（yyyy-MM-dd格式），默认当天
     */
    private String startDate;

    /**
     * 结束日期（yyyy-MM-dd格式），默认当天
     */
    private String endDate;

    /**
     * 任务类型（INBOUND、SEND_INSPECTION、RETURN、OUTBOUND）
     */
    private String taskType;

    /**
     * 任务状态（PENDING、EXECUTING、COMPLETED、CANCELLED、FAILED）
     */
    private String status;

    /**
     * 页码，默认1
     */
    private Integer pageNum = 1;

    /**
     * 每页大小，默认20
     */
    private Integer pageSize = 20;
}

