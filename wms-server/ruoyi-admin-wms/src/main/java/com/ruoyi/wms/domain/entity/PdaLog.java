package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * PDA日志对象 wms_pda_log
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_pda_log")
public class PdaLog extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 日志类型（1:操作记录 2:错误日志 3:网络失败记录 4:系统日志）
     */
    private Integer logType;

    /**
     * PDA设备编号
     */
    private String pdaDeviceNo;

    /**
     * 操作人
     */
    private String operator;

    /**
     * 日志级别（INFO/WARN/ERROR）
     */
    private String logLevel;

    /**
     * 日志内容
     */
    private String logContent;

    /**
     * 错误堆栈（仅错误日志）
     */
    private String errorStack;

    /**
     * 网络请求URL（仅网络失败记录）
     */
    private String requestUrl;

    /**
     * 网络请求方法（仅网络失败记录）
     */
    private String requestMethod;

    /**
     * 网络错误信息（仅网络失败记录）
     */
    private String networkError;

    /**
     * IP地址
     */
    private String ipAddress;

    /**
     * 备注
     */
    private String remark;
}

