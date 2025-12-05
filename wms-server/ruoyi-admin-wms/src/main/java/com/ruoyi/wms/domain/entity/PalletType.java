package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;
import java.math.BigDecimal;

/**
 * 托盘类型对象 wms_pallet_type
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_pallet_type")
public class PalletType extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 托盘类型编号（如：SMALL、LARGE）
     */
    private String typeCode;

    /**
     * 托盘类型名称
     */
    private String typeName;

    /**
     * 固定数量（如：1类托盘132个、2类托盘33个）
     */
    private Integer fixedQuantity;

    /**
     * 长度（cm）
     */
    private BigDecimal length;

    /**
     * 宽度（cm）
     */
    private BigDecimal width;

    /**
     * 高度（cm）
     */
    private BigDecimal height;

    /**
     * 载重（kg）
     */
    private BigDecimal loadCapacity;

    /**
     * AGV识别的载具类型
     */
    private String agvVehicleType;

    /**
     * 状态（0:正常 1:停用）
     */
    private String status;

    /**
     * 备注
     */
    private String remark;
}

