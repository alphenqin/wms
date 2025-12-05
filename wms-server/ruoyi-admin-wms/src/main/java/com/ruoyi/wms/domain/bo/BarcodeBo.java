package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.Barcode;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = Barcode.class, reverseConvertGenerate = false)
public class BarcodeBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    @NotBlank(message = "条码编号不能为空", groups = { AddGroup.class, EditGroup.class })
    private String barcode;

    @NotNull(message = "条码类型不能为空", groups = { AddGroup.class, EditGroup.class })
    private Integer barcodeType;

    private String objectType;
    private Long objectId;
    private String objectCode;
    private String status;
    private String remark;
}

