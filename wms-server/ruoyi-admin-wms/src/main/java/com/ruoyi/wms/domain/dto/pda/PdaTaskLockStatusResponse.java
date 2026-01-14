package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

/**
 * PDA任务锁定状态响应
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaTaskLockStatusResponse {

    private boolean inboundLocked;
    private long inboundCount;

    private boolean inspectionLocked;
    private long inspectionCount;

    private boolean inspectionEmptyReturnLocked;
    private long inspectionEmptyReturnCount;

    private boolean returnCallLocked;
    private long returnCallCount;

    private boolean returnValveLocked;
    private long returnValveCount;

    private boolean outboundLocked;
    private long outboundCount;

    private boolean outboundEmptyReturnLocked;
    private long outboundEmptyReturnCount;
}
