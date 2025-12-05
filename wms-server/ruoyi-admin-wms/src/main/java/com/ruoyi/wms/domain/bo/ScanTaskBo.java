package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.ScanTask;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = ScanTask.class, reverseConvertGenerate = false)
public class ScanTaskBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    private String taskNo;

    @NotNull(message = "任务类型不能为空", groups = { AddGroup.class, EditGroup.class })
    private Integer taskType;

    @NotBlank(message = "条码不能为空", groups = { AddGroup.class, EditGroup.class })
    private String barcode;

    private String operator;
    private String pdaDeviceNo;
    private Integer status;
    private String result;
    private String errorMsg;
    private String remark;
}

