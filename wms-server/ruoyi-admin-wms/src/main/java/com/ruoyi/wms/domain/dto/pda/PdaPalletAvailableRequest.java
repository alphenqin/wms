package com.ruoyi.wms.domain.dto.pda;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * PDA available pallet request.
 */
@Data
public class PdaPalletAvailableRequest implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * Pallet type ID.
     */
    @NotNull(message = "托盘类型不能为空")
    private Long palletTypeId;
}
