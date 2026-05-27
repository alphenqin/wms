package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * 库外空托盘记录 wms_outside_empty_pallet
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_outside_empty_pallet")
public class OutsideEmptyPallet extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value = "id")
    private Long id;

    /**
     * 库外站点，如 Z6-装卸点
     */
    private String stationCode;

    /**
     * 空托盘要回到的原库位
     */
    private String targetBinCode;

    /**
     * 托盘类型：t1 小托盘，t2 大托盘
     */
    private String palletType;

    /**
     * 托盘号，可为空；当前 PDA 侧常用库位号兜底
     */
    private String palletNo;

    /**
     * 来源任务号
     */
    private String sourceTaskNo;

    /**
     * 来源类型：INSPECTION / OUTBOUND
     */
    private String sourceType;

    /**
     * 状态：WAITING / DISPATCHING / RETURNED / FAILED / CANCELLED
     */
    private String status;

    /**
     * 空托回库任务号
     */
    private String returnTaskNo;

    /**
     * 失败原因
     */
    private String errorMsg;
}
