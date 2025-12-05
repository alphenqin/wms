package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * 货区对象 wms_area
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_area")
public class Area extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 货区编号
     */
    private String areaCode;

    /**
     * 货区名称
     */
    private String areaName;

    /**
     * 所属仓库ID
     */
    private Long warehouseId;

    /**
     * 货区类型（1:普通货区 2:置换区 3:其他）
     */
    private Integer areaType;

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

