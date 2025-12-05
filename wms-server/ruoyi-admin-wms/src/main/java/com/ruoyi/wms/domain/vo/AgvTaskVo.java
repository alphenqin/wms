package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.AgvTask;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = AgvTask.class)
public class AgvTaskVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "任务编号")
    private String taskNo;

    @ExcelProperty(value = "任务类型")
    private Integer taskType;

    @ExcelProperty(value = "关联业务单号")
    private String bizOrderNo;

    @ExcelProperty(value = "关联业务单ID")
    private Long bizOrderId;

    @ExcelProperty(value = "托盘编号")
    private String palletCode;

    @ExcelProperty(value = "托盘ID")
    private Long palletId;

    @ExcelProperty(value = "起始货位编号")
    private String fromBinCode;

    @ExcelProperty(value = "起始货位ID")
    private Long fromBinId;

    @ExcelProperty(value = "目标货位编号")
    private String toBinCode;

    @ExcelProperty(value = "目标货位ID")
    private Long toBinId;

    @ExcelProperty(value = "AGV任务ID")
    private String agvTaskId;

    @ExcelProperty(value = "任务状态")
    private Integer status;

    @ExcelProperty(value = "AGV设备编号")
    private String agvDeviceNo;

    @ExcelProperty(value = "下发时间")
    private Date dispatchTime;

    @ExcelProperty(value = "完成时间")
    private Date finishTime;

    @ExcelProperty(value = "错误信息")
    private String errorMsg;

    @ExcelProperty(value = "AGV返回信息")
    private String agvResponse;

    @ExcelProperty(value = "备注")
    private String remark;
}

