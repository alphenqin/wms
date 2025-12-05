package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.WmsConfig;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = WmsConfig.class, reverseConvertGenerate = false)
public class WmsConfigBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    @NotBlank(message = "配置键不能为空", groups = { AddGroup.class, EditGroup.class })
    private String configKey;

    @NotBlank(message = "配置值不能为空", groups = { AddGroup.class, EditGroup.class })
    private String configValue;

    @NotNull(message = "配置类型不能为空", groups = { AddGroup.class, EditGroup.class })
    private Integer configType;

    private String configGroup;
    private String configDesc;
    private String status;
    private String remark;
}

