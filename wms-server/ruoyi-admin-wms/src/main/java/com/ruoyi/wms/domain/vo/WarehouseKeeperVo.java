package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.WarehouseKeeper;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = WarehouseKeeper.class)
public class WarehouseKeeperVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "库管员编号")
    private String keeperCode;

    @ExcelProperty(value = "库管员姓名")
    private String keeperName;

    @ExcelProperty(value = "用户ID")
    private Long userId;

    @ExcelProperty(value = "所属仓库ID")
    private Long warehouseId;

    @ExcelProperty(value = "所属仓库")
    private String warehouseName;

    @ExcelProperty(value = "岗位")
    private String post;

    @ExcelProperty(value = "入职日期")
    private Date joinDate;

    @ExcelProperty(value = "状态")
    private String status;

    @ExcelProperty(value = "备注")
    private String remark;
}

