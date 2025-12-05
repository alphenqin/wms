package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.PdaLog;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = PdaLog.class)
public class PdaLogVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "日志类型")
    private Integer logType;

    @ExcelProperty(value = "PDA设备编号")
    private String pdaDeviceNo;

    @ExcelProperty(value = "操作人")
    private String operator;

    @ExcelProperty(value = "日志级别")
    private String logLevel;

    @ExcelProperty(value = "日志内容")
    private String logContent;

    @ExcelProperty(value = "错误堆栈")
    private String errorStack;

    @ExcelProperty(value = "请求URL")
    private String requestUrl;

    @ExcelProperty(value = "请求方法")
    private String requestMethod;

    @ExcelProperty(value = "网络错误")
    private String networkError;

    @ExcelProperty(value = "IP地址")
    private String ipAddress;

    @ExcelProperty(value = "备注")
    private String remark;
}

