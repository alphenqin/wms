package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.PdaLog;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = PdaLog.class, reverseConvertGenerate = false)
public class PdaLogBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    private Integer logType;
    private String pdaDeviceNo;
    private String operator;
    private String logLevel;
    private String logContent;
    private String errorStack;
    private String requestUrl;
    private String requestMethod;
    private String networkError;
    private String ipAddress;
    private String remark;
}

