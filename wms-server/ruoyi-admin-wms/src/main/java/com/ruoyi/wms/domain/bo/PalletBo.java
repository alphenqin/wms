package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.Pallet;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = Pallet.class, reverseConvertGenerate = false)
public class PalletBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    @NotBlank(message = "托盘编号不能为空", groups = { AddGroup.class, EditGroup.class })
    private String palletCode;

    @NotNull(message = "托盘类型不能为空", groups = { AddGroup.class, EditGroup.class })
    private Long palletTypeId;

    private Long currentBinId;
    private String currentBinCode;
    private Integer isEmpty;
    private Integer isBound;
    private Integer barcodeEnabled;
    private String status;
    private String remark;
}

