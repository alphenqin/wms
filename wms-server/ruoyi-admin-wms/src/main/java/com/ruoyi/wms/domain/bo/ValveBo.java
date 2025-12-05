package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.Valve;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = Valve.class, reverseConvertGenerate = false)
public class ValveBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    @NotBlank(message = "阀门编号不能为空", groups = { AddGroup.class, EditGroup.class })
    private String valveNo;

    private Long materialTypeId;
    private String model;
    private String manufacturer;
    private String batchNo;
    private Long palletId;
    private String palletCode;
    private Long currentBinId;
    private String currentBinCode;
    private Integer status;
    private Date productionDate;
    private Date expiryDate;
    private String remark;
}

