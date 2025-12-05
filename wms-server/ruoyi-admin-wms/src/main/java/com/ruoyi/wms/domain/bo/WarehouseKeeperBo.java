package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.WarehouseKeeper;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = WarehouseKeeper.class, reverseConvertGenerate = false)
public class WarehouseKeeperBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    private String keeperCode;

    @NotBlank(message = "库管员姓名不能为空", groups = { AddGroup.class, EditGroup.class })
    private String keeperName;

    private Long userId;
    private Long warehouseId;
    private String post;
    private Date joinDate;
    private String status;
    private String remark;
}

