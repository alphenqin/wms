package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.PalletType;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = PalletType.class, reverseConvertGenerate = false)
public class PalletTypeBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    @NotBlank(message = "托盘类型编号不能为空", groups = { AddGroup.class, EditGroup.class })
    private String typeCode;

    @NotBlank(message = "托盘类型名称不能为空", groups = { AddGroup.class, EditGroup.class })
    private String typeName;

    private Integer fixedQuantity;
    private BigDecimal length;
    private BigDecimal width;
    private BigDecimal height;
    private BigDecimal loadCapacity;
    private String agvVehicleType;
    private String status;
    private String remark;
}

