package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * AGV任务对象 wms_agv_task
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_agv_task")
public class AgvTask extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 任务编号（outID，由WMS生成）
     */
    private String taskNo;

    /**
     * 任务类型（1:入库任务 2:送检任务 3:回库任务 4:出库任务）
     */
    private Integer taskType;

    /**
     * 关联业务单号（入库单号、出库单号等）
     */
    private String bizOrderNo;

    /**
     * 关联业务单ID
     */
    private Long bizOrderId;

    /**
     * 托盘编号
     */
    private String palletCode;

    /**
     * 托盘ID
     */
    private Long palletId;

    /**
     * 起始货位编号
     */
    private String fromBinCode;

    /**
     * 起始货位ID
     */
    private Long fromBinId;

    /**
     * 目标货位编号
     */
    private String toBinCode;

    /**
     * 目标货位ID
     */
    private Long toBinId;

    /**
     * AGV调度系统返回的任务ID
     */
    private String agvTaskId;

    /**
     * 任务状态（0:PENDING待处理 1:EXECUTING执行中 2:FINISHED已完成 3:FAILED失败 4:CANCELLED已取消）
     */
    private Integer status;

    /**
     * AGV设备编号
     */
    private String agvDeviceNo;

    /**
     * 下发时间
     */
    private java.util.Date dispatchTime;

    /**
     * 完成时间
     */
    private java.util.Date finishTime;

    /**
     * 错误信息
     */
    private String errorMsg;

    /**
     * AGV返回的详细信息
     */
    private String agvResponse;

    /**
     * 备注
     */
    private String remark;
}

