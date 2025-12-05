package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.Valve;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = Valve.class)
public class ValveVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "阀门编号")
    private String valveNo;

    @ExcelProperty(value = "物料类型ID")
    private Long materialTypeId;

    @ExcelProperty(value = "物料类型")
    private String materialTypeName;

    @ExcelProperty(value = "型号")
    private String model;

    @ExcelProperty(value = "厂家")
    private String manufacturer;

    @ExcelProperty(value = "批次")
    private String batchNo;

    @ExcelProperty(value = "所属托盘ID")
    private Long palletId;

    @ExcelProperty(value = "所属托盘编号")
    private String palletCode;

    @ExcelProperty(value = "当前货位ID")
    private Long currentBinId;

    @ExcelProperty(value = "当前货位编号")
    private String currentBinCode;

    @ExcelProperty(value = "状态")
    private Integer status;

    @ExcelProperty(value = "生产日期")
    private Date productionDate;

    @ExcelProperty(value = "过期日期")
    private Date expiryDate;

    @ExcelProperty(value = "备注")
    private String remark;
}

