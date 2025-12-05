package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.DataBackup;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = DataBackup.class, reverseConvertGenerate = false)
public class DataBackupBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    private String backupNo;
    private String backupName;
    private Integer backupType;
    private String filePath;
    private Long fileSize;
    private Date backupTime;
    private Integer status;
    private String errorMsg;
    private Integer isAuto;
    private String remark;
}

