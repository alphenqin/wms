package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.OutsideStation;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = OutsideStation.class, reverseConvertGenerate = false)
public class OutsideStationBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    @NotBlank(message = "库外站点不能为空", groups = { AddGroup.class, EditGroup.class })
    private String stationCode;

    @NotBlank(message = "托盘类型不能为空", groups = { AddGroup.class, EditGroup.class })
    private String palletType;

    private String status;
    private String sourceBinCode;
    private String palletNo;
    private String sourceTaskNo;
    private String sourceType;
    private String returnTaskNo;
    private String errorMsg;
}
