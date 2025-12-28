package com.ruoyi.wms.domain.dto.pda;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * PDA任务取消请求DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaTaskCancelRequest {

    /**
     * 任务编号（outID）
     */
    @NotBlank(message = "任务编号不能为空")
    private String outID;

    /**
     * PDA设备编号
     */
    @NotBlank(message = "设备编码不能为空")
    private String deviceCode;
}
