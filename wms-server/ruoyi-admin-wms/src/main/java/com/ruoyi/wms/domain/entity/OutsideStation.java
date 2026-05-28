package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * 库外站点状态 wms_outside_station
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_outside_station")
public class OutsideStation extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value = "id")
    private Long id;

    /**
     * 库外站点，如 Z6-装卸点
     */
    private String stationCode;

    /**
     * 托盘类型：t1 小托盘，t2 大托盘
     */
    private String palletType;

    /**
     * 状态：IDLE / OCCUPIED / RETURNING
     */
    private String status;

    /**
     * 空托盘原库位/回库目标库位
     */
    private String sourceBinCode;

    /**
     * 托盘号
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
     * 空托回库任务号
     */
    private String returnTaskNo;

    /**
     * 失败原因
     */
    private String errorMsg;
}
