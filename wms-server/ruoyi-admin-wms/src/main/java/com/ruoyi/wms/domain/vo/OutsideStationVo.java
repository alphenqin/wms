package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.OutsideStation;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

@Data
@EqualsAndHashCode(callSuper = true)
@ExcelIgnoreUnannotated
@AutoMapper(target = OutsideStation.class)
public class OutsideStationVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "库外站点")
    private String stationCode;

    @ExcelProperty(value = "托盘类型")
    private String palletType;

    @ExcelProperty(value = "状态")
    private String status;

    @ExcelProperty(value = "回库目标库位")
    private String sourceBinCode;

    @ExcelProperty(value = "托盘号")
    private String palletNo;

    @ExcelProperty(value = "来源任务号")
    private String sourceTaskNo;

    @ExcelProperty(value = "来源类型")
    private String sourceType;

    @ExcelProperty(value = "空托回库任务号")
    private String returnTaskNo;

    @ExcelProperty(value = "失败原因")
    private String errorMsg;
}
