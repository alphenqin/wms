package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * AGV开放接口任务记录
 * 对应外部调度系统的 taskSent/taskResult 数据
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_agv_open_task")
public class AgvOpenTask extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    @TableId
    private Long id;

    /**
     * 外部业务id outID
     */
    private String outId;

    /**
     * 调度系统任务编号 taskCode（可选）
     */
    private String taskCode;

    /**
     * AGV任务类型 01/05/10/12/13/18
     */
    private String taskType;

    /**
     * 是否有序
     */
    private String isOrder;

    /**
     * agv范围
     */
    private String agvRange;

    /**
     * 任务级别
     */
    private String level;

    /**
     * 被清空的外部业务id
     */
    private String clearOutId;

    /**
     * 作业点数据(JSON串)
     */
    private String pointsJson;

    /**
     * 最新任务状态 01等待 02执行中 08完成 09强制清空
     */
    private String status;

    /**
     * 执行AGV编号
     */
    private String agvCode;

    /**
     * 最近一次接口返回码
     */
    private String responseCode;

    /**
     * 最近一次接口返回消息
     */
    private String responseMessage;

    /**
     * 最近一次下发请求报文
     */
    private String requestPayload;

    /**
     * 最近一次结果报文
     */
    private String lastResult;

    private String remark;
}

