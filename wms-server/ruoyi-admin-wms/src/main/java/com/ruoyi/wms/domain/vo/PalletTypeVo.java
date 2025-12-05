package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.PalletType;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;
import java.math.BigDecimal;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = PalletType.class)
public class PalletTypeVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "托盘类型编号")
    private String typeCode;

    @ExcelProperty(value = "托盘类型名称")
    private String typeName;

    @ExcelProperty(value = "固定数量")
    private Integer fixedQuantity;

    @ExcelProperty(value = "长度(cm)")
    private BigDecimal length;

    @ExcelProperty(value = "宽度(cm)")
    private BigDecimal width;

    @ExcelProperty(value = "高度(cm)")
    private BigDecimal height;

    @ExcelProperty(value = "载重(kg)")
    private BigDecimal loadCapacity;

    @ExcelProperty(value = "AGV载具类型")
    private String agvVehicleType;

    @ExcelProperty(value = "状态")
    private String status;

    @ExcelProperty(value = "备注")
    private String remark;
}

