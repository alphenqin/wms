package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * PDA available pallet response.
 */
@Data
public class PdaPalletAvailableResponse implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * Pallet number.
     */
    private String palletNo;

    /**
     * Bin code.
     */
    private String binCode;
}
