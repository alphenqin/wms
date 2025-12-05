package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * 条码信息对象 wms_barcode
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_barcode")
public class Barcode extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 条码编号
     */
    private String barcode;

    /**
     * 条码类型（1:托盘二维码 2:阀门二维码/条码 3:库位条码）
     */
    private Integer barcodeType;

    /**
     * 关联对象类型（pallet/valve/bin）
     */
    private String objectType;

    /**
     * 关联对象ID
     */
    private Long objectId;

    /**
     * 关联对象编号
     */
    private String objectCode;

    /**
     * 状态（0:正常 1:停用）
     */
    private String status;

    /**
     * 备注
     */
    private String remark;
}

