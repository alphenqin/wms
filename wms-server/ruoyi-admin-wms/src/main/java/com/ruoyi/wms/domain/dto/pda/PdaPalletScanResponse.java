package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * PDA托盘扫码响应DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaPalletScanResponse implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 托盘编号
     */
    private String palletNo;

    /**
     * 托盘型号：SMALL（小托盘，132个）/ LARGE（大托盘，33个）
     */
    private String palletType;

    /**
     * 库前置换区站点编码（与AGV调度系统的pointCode对应）
     */
    private String swapStation;

    /**
     * 库位号，与AGV调度系统的binCode一致
     */
    private String binCode;
}

