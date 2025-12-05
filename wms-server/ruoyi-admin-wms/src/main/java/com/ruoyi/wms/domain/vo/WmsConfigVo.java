package com.ruoyi.wms.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.mybatis.core.domain.BaseVo;
import com.ruoyi.wms.domain.entity.WmsConfig;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;

@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = WmsConfig.class)
public class WmsConfigVo extends BaseVo {

    @Serial
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "ID")
    private Long id;

    @ExcelProperty(value = "配置键")
    private String configKey;

    @ExcelProperty(value = "配置值")
    private String configValue;

    @ExcelProperty(value = "配置类型")
    private Integer configType;

    @ExcelProperty(value = "配置分组")
    private String configGroup;

    @ExcelProperty(value = "配置描述")
    private String configDesc;

    @ExcelProperty(value = "状态")
    private String status;

    @ExcelProperty(value = "备注")
    private String remark;
}

