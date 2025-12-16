package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.AgvOpenTask;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = AgvOpenTask.class)
public class AgvOpenTaskVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty("ID")
    private Long id;

    @ExcelProperty("外部业务ID")
    private String outId;

    @ExcelProperty("调度任务编号")
    private String taskCode;

    @ExcelProperty("任务类型")
    private String taskType;

    @ExcelProperty("是否有序")
    private String isOrder;

    @ExcelProperty("AGV范围")
    private String agvRange;

    @ExcelProperty("任务级别")
    private String level;

    @ExcelProperty("清空外部业务ID")
    private String clearOutId;

    @ExcelProperty("作业点JSON")
    private String pointsJson;

    @ExcelProperty("状态")
    private String status;

    @ExcelProperty("AGV编号")
    private String agvCode;

    @ExcelProperty("返回码")
    private String responseCode;

    @ExcelProperty("返回消息")
    private String responseMessage;

    @ExcelProperty("请求报文")
    private String requestPayload;

    @ExcelProperty("结果报文")
    private String lastResult;

    @ExcelProperty("备注")
    private String remark;
}

