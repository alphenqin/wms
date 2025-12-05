package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;
import java.util.Date;

/**
 * 阀门对象 wms_valve
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_valve")
public class Valve extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 阀门编号（valveNo）
     */
    private String valveNo;

    /**
     * 物料类型ID（ValveType）
     */
    private Long materialTypeId;

    /**
     * 型号（如：DN50、DN80）
     */
    private String model;

    /**
     * 厂家
     */
    private String manufacturer;

    /**
     * 批次
     */
    private String batchNo;

    /**
     * 所属托盘ID
     */
    private Long palletId;

    /**
     * 所属托盘编号
     */
    private String palletCode;

    /**
     * 当前所在货位ID
     */
    private Long currentBinId;

    /**
     * 当前所在货位编号
     */
    private String currentBinCode;

    /**
     * 状态（0:在库 1:检测中 2:已检测 3:已出库）
     */
    private Integer status;

    /**
     * 生产日期
     */
    private Date productionDate;

    /**
     * 过期日期
     */
    private Date expiryDate;

    /**
     * 备注
     */
    private String remark;
}

