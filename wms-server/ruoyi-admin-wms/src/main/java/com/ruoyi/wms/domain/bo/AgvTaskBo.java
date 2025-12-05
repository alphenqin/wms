package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.AgvTask;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = AgvTask.class, reverseConvertGenerate = false)
public class AgvTaskBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    private String taskNo;
    private Integer taskType;
    private String bizOrderNo;
    private Long bizOrderId;
    private String palletCode;
    private Long palletId;
    private String fromBinCode;
    private Long fromBinId;
    private String toBinCode;
    private Long toBinId;
    private String agvTaskId;
    private Integer status;
    private String agvDeviceNo;
    private Date dispatchTime;
    private Date finishTime;
    private String errorMsg;
    private String agvResponse;
    private String remark;
}

