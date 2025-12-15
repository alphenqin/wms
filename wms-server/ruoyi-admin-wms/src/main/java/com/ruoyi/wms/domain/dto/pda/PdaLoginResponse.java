package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

/**
 * PDA登录响应DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaLoginResponse implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 访问令牌
     */
    private String token;

    /**
     * Token过期时间（yyyy-MM-dd HH:mm:ss格式）
     */
    private String expireAt;

    /**
     * 用户姓名
     */
    private String userName;

    /**
     * 用户角色列表
     */
    private List<String> roles;
}

