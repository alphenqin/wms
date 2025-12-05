package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * PDA操作记录对象 wms_pda_operation
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_pda_operation")
public class PdaOperation extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 操作编号
     */
    private String operationNo;

    /**
     * 操作类型（1:托盘扫码 2:阀门扫码 3:库位扫码 4:入库 5:出库 6:送检 7:回库 8:盘点 9:任务取消）
     */
    private Integer operationType;

    /**
     * 操作人
     */
    private String operator;

    /**
     * PDA设备编号
     */
    private String pdaDeviceNo;

    /**
     * 扫描的条码/编号
     */
    private String scannedCode;

    /**
     * 关联业务单号
     */
    private String bizOrderNo;

    /**
     * 关联业务单ID
     */
    private Long bizOrderId;

    /**
     * 操作结果（0:失败 1:成功）
     */
    private Integer result;

    /**
     * 操作结果描述
     */
    private String resultMsg;

    /**
     * 错误信息
     */
    private String errorMsg;

    /**
     * 操作数据（JSON格式，存储操作相关的详细信息）
     */
    private String operationData;

    /**
     * 备注
     */
    private String remark;
}

