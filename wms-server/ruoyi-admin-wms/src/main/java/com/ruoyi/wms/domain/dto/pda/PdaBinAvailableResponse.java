package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

/**
 * PDA获取可用库位响应DTO
 *
 * @author wms
 * @date 2025-12-22
 */
@Data
public class PdaBinAvailableResponse {

    /**
     * 库位号
     */
    private String binCode;
}
