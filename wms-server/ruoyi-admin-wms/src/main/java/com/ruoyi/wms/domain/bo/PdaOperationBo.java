package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.PdaOperation;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = PdaOperation.class, reverseConvertGenerate = false)
public class PdaOperationBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    private String operationNo;
    private Integer operationType;
    private String operator;
    private String pdaDeviceNo;
    private String scannedCode;
    private String bizOrderNo;
    private Long bizOrderId;
    private Integer result;
    private String resultMsg;
    private String errorMsg;
    private String operationData;
    private String remark;
}

