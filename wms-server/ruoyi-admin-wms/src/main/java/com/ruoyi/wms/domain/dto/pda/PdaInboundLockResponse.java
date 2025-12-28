package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

/**
 * 入库锁定状态响应
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaInboundLockResponse {

    /**
     * 是否锁定
     */
    private boolean locked;

    /**
     * 未完成入库任务数量
     */
    private long count;
}
