package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

/**
 * PDA任务下发响应DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaTaskDispatchResponse {

    /**
     * 任务编号（outID）
     */
    private String outID;

    /**
     * 业务任务类型
     */
    private String taskType;

    /**
     * 任务状态（PENDING/EXECUTING/COMPLETED/CANCELLED/FAILED）
     */
    private String status;

    /**
     * 目标站点/库位
     */
    private String toBinCode;
}
