package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * 托盘对象 wms_pallet
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_pallet")
public class Pallet extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 托盘编号
     */
    private String palletCode;

    /**
     * 托盘类型ID
     */
    private Long palletTypeId;

    /**
     * 当前所在货位ID（binCode对应的ID）
     */
    private Long currentBinId;

    /**
     * 当前所在货位编号（binCode）
     */
    private String currentBinCode;

    /**
     * 是否为空托（0:否 1:是）
     */
    private Integer isEmpty;

    /**
     * 是否已绑定物料（0:否 1:是）
     */
    private Integer isBound;

    /**
     * 条码是否启用（0:否 1:是）
     */
    private Integer barcodeEnabled;

    /**
     * 状态（0:正常 1:禁用）
     */
    private String status;

    /**
     * 备注
     */
    private String remark;
}

