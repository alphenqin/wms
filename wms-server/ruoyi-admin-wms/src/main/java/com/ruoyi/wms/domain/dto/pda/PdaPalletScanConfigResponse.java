package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

/**
 * PDA托盘扫码开关响应DTO
 *
 * @author wms
 * @date 2025-12-22
 */
@Data
public class PdaPalletScanConfigResponse {

    /**
     * 是否启用托盘扫码
     */
    private Boolean enabled;
}
