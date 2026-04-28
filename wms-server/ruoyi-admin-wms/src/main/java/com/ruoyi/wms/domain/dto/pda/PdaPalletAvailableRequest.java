package com.ruoyi.wms.domain.dto.pda;

import jakarta.validation.constraints.NotBlank;
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

    @NotBlank(message = "库外站点不能为空")
    private String outsideSite;
}
