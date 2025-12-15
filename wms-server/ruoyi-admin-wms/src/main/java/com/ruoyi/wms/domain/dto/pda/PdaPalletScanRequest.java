package com.ruoyi.wms.domain.dto.pda;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * PDA托盘扫码请求DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaPalletScanRequest {

    /**
     * 托盘条码/二维码
     */
    @NotBlank(message = "条码不能为空")
    private String barcode;
}

