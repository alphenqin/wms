package com.ruoyi.wms.domain.dto.pda;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * PDA任务下发请求DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaTaskDispatchRequest {

    /**
     * 业务任务类型（INBOUND、SEND_INSPECTION、RETURN、OUTBOUND）
     */
    @NotBlank(message = "任务类型不能为空")
    private String taskType;

    /**
     * 外部任务编号（PDA生成，可选）
     */
    private String outID;

    /**
     * PDA设备编号
     */
    @NotBlank(message = "设备编码不能为空")
    private String deviceCode;

    /**
     * 托盘号
     */
    private String palletNo;

    /**
     * 起始站点/库位
     */
    @NotBlank(message = "起始站点不能为空")
    private String fromBinCode;

    /**
     * 目标站点/库位
     */
    @NotBlank(message = "目标站点不能为空")
    private String toBinCode;

    /**
     * 物料编码（可选，空托任务可不传）
     */
    private String matCode;

    /**
     * AGV范围（可选）
     */
    private String agvRange;

    /**
     * 阀门编号（可选）
     */
    private String valveNo;

    /**
     * 送检目标区域（可选）
     */
    private String inspectionArea;

    /**
     * 备注
     */
    private String remark;
}
