package com.ruoyi.wms.domain.dto.pda;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * PDA登录请求DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaLoginRequest {

    /**
     * 用户名
     */
    @NotBlank(message = "用户名不能为空")
    private String username;

    /**
     * 密码
     */
    @NotBlank(message = "密码不能为空")
    private String password;

    /**
     * 设备编码
     */
    @NotBlank(message = "设备编码不能为空")
    private String deviceCode;
}

