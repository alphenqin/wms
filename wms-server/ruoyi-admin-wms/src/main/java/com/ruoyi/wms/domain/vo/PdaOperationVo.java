package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.PdaOperation;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = PdaOperation.class)
public class PdaOperationVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "操作编号")
    private String operationNo;

    @ExcelProperty(value = "操作类型")
    private Integer operationType;

    @ExcelProperty(value = "操作人")
    private String operator;

    @ExcelProperty(value = "PDA设备编号")
    private String pdaDeviceNo;

    @ExcelProperty(value = "扫描的条码")
    private String scannedCode;

    @ExcelProperty(value = "关联业务单号")
    private String bizOrderNo;

    @ExcelProperty(value = "操作结果")
    private Integer result;

    @ExcelProperty(value = "结果描述")
    private String resultMsg;

    @ExcelProperty(value = "错误信息")
    private String errorMsg;

    @ExcelProperty(value = "操作数据")
    private String operationData;

    @ExcelProperty(value = "备注")
    private String remark;
}

