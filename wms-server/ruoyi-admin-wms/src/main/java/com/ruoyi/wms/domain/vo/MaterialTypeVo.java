package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.MaterialType;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = MaterialType.class)
public class MaterialTypeVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "物料类型编号")
    private String typeCode;

    @ExcelProperty(value = "物料类型名称")
    private String typeName;

    @ExcelProperty(value = "排序")
    private Long orderNum;

    @ExcelProperty(value = "状态")
    private String status;

    @ExcelProperty(value = "备注")
    private String remark;
}

