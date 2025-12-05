package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.Barcode;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = Barcode.class)
public class BarcodeVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "条码编号")
    private String barcode;

    @ExcelProperty(value = "条码类型")
    private Integer barcodeType;

    @ExcelProperty(value = "关联对象类型")
    private String objectType;

    @ExcelProperty(value = "关联对象ID")
    private Long objectId;

    @ExcelProperty(value = "关联对象编号")
    private String objectCode;

    @ExcelProperty(value = "状态")
    private String status;

    @ExcelProperty(value = "备注")
    private String remark;
}

