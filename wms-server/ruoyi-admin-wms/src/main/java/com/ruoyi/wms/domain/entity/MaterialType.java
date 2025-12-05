package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * 物料类型对象 wms_material_type
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_material_type")
public class MaterialType extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 物料类型编号
     */
    private String typeCode;

    /**
     * 物料类型名称（如：阀门）
     */
    private String typeName;

    /**
     * 排序
     */
    private Long orderNum;

    /**
     * 状态（0:正常 1:停用）
     */
    private String status;

    /**
     * 备注
     */
    private String remark;
}

