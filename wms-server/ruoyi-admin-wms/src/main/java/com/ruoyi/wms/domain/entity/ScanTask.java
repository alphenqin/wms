package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * 扫码任务对象 wms_scan_task
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_scan_task")
public class ScanTask extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 任务编号
     */
    private String taskNo;

    /**
     * 任务类型（1:托盘扫码 2:阀门扫码 3:库位扫码）
     */
    private Integer taskType;

    /**
     * 扫描的条码
     */
    private String barcode;

    /**
     * 操作人
     */
    private String operator;

    /**
     * PDA设备编号
     */
    private String pdaDeviceNo;

    /**
     * 任务状态（0:待处理 1:处理中 2:已完成 3:失败）
     */
    private Integer status;

    /**
     * 处理结果
     */
    private String result;

    /**
     * 错误信息
     */
    private String errorMsg;

    /**
     * 备注
     */
    private String remark;
}

