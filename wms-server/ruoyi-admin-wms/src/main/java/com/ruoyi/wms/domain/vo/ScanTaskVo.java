package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.ScanTask;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = ScanTask.class)
public class ScanTaskVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "任务编号")
    private String taskNo;

    @ExcelProperty(value = "任务类型")
    private Integer taskType;

    @ExcelProperty(value = "扫描的条码")
    private String barcode;

    @ExcelProperty(value = "操作人")
    private String operator;

    @ExcelProperty(value = "PDA设备编号")
    private String pdaDeviceNo;

    @ExcelProperty(value = "任务状态")
    private Integer status;

    @ExcelProperty(value = "处理结果")
    private String result;

    @ExcelProperty(value = "错误信息")
    private String errorMsg;

    @ExcelProperty(value = "备注")
    private String remark;
}

