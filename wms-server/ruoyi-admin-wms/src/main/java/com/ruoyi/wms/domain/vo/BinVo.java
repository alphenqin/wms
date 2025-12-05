package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.Bin;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;
import java.math.BigDecimal;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = Bin.class)
public class BinVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @ExcelProperty(value = "ID")
    private Long id;

    /**
     * 货位编号（binCode）
     */
    @ExcelProperty(value = "货位编号")
    private String binCode;

    /**
     * 货位名称
     */
    @ExcelProperty(value = "货位名称")
    private String binName;

    /**
     * 所属仓库ID
     */
    @ExcelProperty(value = "所属仓库ID")
    private Long warehouseId;

    /**
     * 所属仓库名称
     */
    @ExcelProperty(value = "所属仓库")
    private String warehouseName;

    /**
     * 所属货区ID
     */
    @ExcelProperty(value = "所属货区ID")
    private Long areaId;

    /**
     * 所属货区名称
     */
    @ExcelProperty(value = "所属货区")
    private String areaName;

    /**
     * 货位类型（1:普通货位 2:暂存位 3:其他）
     */
    @ExcelProperty(value = "货位类型")
    private Integer binType;

    /**
     * 温区（1:常温 2:冷藏 3:冷冻 4:其他）
     */
    @ExcelProperty(value = "温区")
    private Integer temperatureZone;

    /**
     * 容量（单位：立方米或托盘数）
     */
    @ExcelProperty(value = "容量")
    private BigDecimal capacity;

    /**
     * 当前占用容量
     */
    @ExcelProperty(value = "已用容量")
    private BigDecimal usedCapacity;

    /**
     * 状态（0:空闲 1:占用 2:禁用 3:锁定-任务中）
     */
    @ExcelProperty(value = "状态")
    private Integer status;

    /**
     * 排序
     */
    @ExcelProperty(value = "排序")
    private Long orderNum;

    /**
     * 备注
     */
    @ExcelProperty(value = "备注")
    private String remark;
}

