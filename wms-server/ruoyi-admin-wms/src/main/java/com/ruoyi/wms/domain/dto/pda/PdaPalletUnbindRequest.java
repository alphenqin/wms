package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

import java.io.Serializable;

/**
 * PDA pallet unbind request.
 */
@Data
public class PdaPalletUnbindRequest implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * 托盘编号
     */
    private String palletNo;

    /**
     * 出厂编号
     */
    private String valveNo;

    /**
     * 库位号
     */
    private String binCode;
}
