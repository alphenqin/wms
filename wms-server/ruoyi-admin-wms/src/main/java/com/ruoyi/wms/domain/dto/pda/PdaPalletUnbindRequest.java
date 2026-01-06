package com.ruoyi.wms.domain.dto.pda;

import jakarta.validation.constraints.NotBlank;
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
    @NotBlank(message = "托盘号不能为空")
    private String palletNo;
}
