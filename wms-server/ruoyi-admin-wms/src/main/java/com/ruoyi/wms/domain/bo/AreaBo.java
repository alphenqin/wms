package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.Area;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = Area.class, reverseConvertGenerate = false)
public class AreaBo extends BaseEntity {

    /**
     * 主键ID
     */
    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    /**
     * 货区编号
     */
    private String areaCode;

    /**
     * 货区名称
     */
    @NotBlank(message = "货区名称不能为空", groups = { AddGroup.class, EditGroup.class })
    private String areaName;

    /**
     * 所属仓库ID
     */
    @NotNull(message = "所属仓库不能为空", groups = { AddGroup.class, EditGroup.class })
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

