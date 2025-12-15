package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * PDA任务信息DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaTaskInfo implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 任务编号（AGV生成，格式：R/S/H/C + 时间戳）
     */
    private String outID;

    /**
     * 业务任务类型（INBOUND、SEND_INSPECTION、RETURN、OUTBOUND）
     */
    private String taskType;

    /**
     * 任务状态（PENDING、EXECUTING、COMPLETED、CANCELLED、FAILED）
     */
    private String status;

    /**
     * 创建时间（yyyy-MM-dd HH:mm:ss格式）
     */
    private String createTime;

    /**
     * 托盘号
     */
    private String palletNo;

    /**
     * 阀门编号
     */
    private String valveNo;

    /**
     * 物料编码
     */
    private String matCode;

    /**
     * 库位号
     */
    private String binCode;
}

