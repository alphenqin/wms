package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

/**
 * PDA获取可用库位请求DTO
 *
 * @author wms
 * @date 2025-12-22
 */
@Data
public class PdaBinAvailableRequest {

    /**
     * 仓库ID（可选）
     */
    private Long warehouseId;

    /**
     * 货区ID（可选）
     */
    private Long areaId;
}
