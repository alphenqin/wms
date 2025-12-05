package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.Pallet;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = Pallet.class)
public class PalletVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "托盘编号")
    private String palletCode;

    @ExcelProperty(value = "托盘类型ID")
    private Long palletTypeId;

    @ExcelProperty(value = "托盘类型")
    private String palletTypeName;

    @ExcelProperty(value = "当前货位ID")
    private Long currentBinId;

    @ExcelProperty(value = "当前货位编号")
    private String currentBinCode;

    @ExcelProperty(value = "是否空托")
    private Integer isEmpty;

    @ExcelProperty(value = "是否绑定物料")
    private Integer isBound;

    @ExcelProperty(value = "状态")
    private String status;

    @ExcelProperty(value = "备注")
    private String remark;
}

