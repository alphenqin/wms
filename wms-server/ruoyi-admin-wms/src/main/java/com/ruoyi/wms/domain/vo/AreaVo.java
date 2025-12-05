package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.Area;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = Area.class)
public class AreaVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @ExcelProperty(value = "ID")
    private Long id;

    /**
     * 货区编号
     */
    @ExcelProperty(value = "货区编号")
    private String areaCode;

    /**
     * 货区名称
     */
    @ExcelProperty(value = "货区名称")
    private String areaName;

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
     * 货区类型（1:普通货区 2:置换区 3:其他）
     */
    @ExcelProperty(value = "货区类型")
    private Integer areaType;

    /**
     * 排序
     */
    @ExcelProperty(value = "排序")
    private Long orderNum;

    /**
     * 状态（0:正常 1:停用）
     */
    @ExcelProperty(value = "状态")
    private String status;

    /**
     * 备注
     */
    @ExcelProperty(value = "备注")
    private String remark;
}

