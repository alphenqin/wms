package com.ruoyi.wms.domain.bo;

import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.Bin;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = Bin.class, reverseConvertGenerate = false)
public class BinBo extends BaseEntity {

    /**
     * 主键ID
     */
    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    /**
     * 货位编号（binCode）
     */
    @NotBlank(message = "货位编号不能为空", groups = { AddGroup.class, EditGroup.class })
    private String binCode;

    /**
     * 货位名称
     */
    private String binName;

    /**
     * 所属仓库ID
     */
    @NotNull(message = "所属仓库不能为空", groups = { AddGroup.class, EditGroup.class })
    private Long warehouseId;

    /**
     * 所属货区ID
     */
    private Long areaId;

    /**
     * 货位类型（1:普通货位 2:暂存位 3:其他）
     */
    private Integer binType;

    /**
     * 温区（1:常温 2:冷藏 3:冷冻 4:其他）
     */
    private Integer temperatureZone;

    /**
     * 容量（单位：立方米或托盘数）
     */
    private BigDecimal capacity;

    /**
     * 当前占用容量
     */
    private BigDecimal usedCapacity;

    /**
     * 状态（0:空闲 1:占用 2:禁用 3:锁定-任务中）
     */
    private Integer status;

    /**
     * 排序
     */
    private Long orderNum;

    /**
     * 备注
     */
    private String remark;
}

