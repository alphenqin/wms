package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * PDA pallet type item.
 */
@Data
public class PdaPalletTypeResponse implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * Pallet type ID.
     */
    private Long id;

    /**
     * Pallet type code.
     */
    private String typeCode;

    /**
     * Pallet type name.
     */
    private String typeName;
}
