package com.ruoyi.wms.domain.dto.pda;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * PDA托盘扫码开关查询请求DTO
 *
 * @author wms
 * @date 2025-12-22
 */
@Data
public class PdaPalletScanConfigRequest {

    /**
     * 设备编码
     */
    @NotBlank(message = "设备编码不能为空")
    private String deviceCode;
}
