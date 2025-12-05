package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.DataBackup;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = DataBackup.class)
public class DataBackupVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "备份编号")
    private String backupNo;

    @ExcelProperty(value = "备份名称")
    private String backupName;

    @ExcelProperty(value = "备份类型")
    private Integer backupType;

    @ExcelProperty(value = "备份文件路径")
    private String filePath;

    @ExcelProperty(value = "文件大小(MB)")
    private Long fileSize;

    @ExcelProperty(value = "备份时间")
    private Date backupTime;

    @ExcelProperty(value = "备份状态")
    private Integer status;

    @ExcelProperty(value = "错误信息")
    private String errorMsg;

    @ExcelProperty(value = "是否自动备份")
    private Integer isAuto;

    @ExcelProperty(value = "备注")
    private String remark;
}

