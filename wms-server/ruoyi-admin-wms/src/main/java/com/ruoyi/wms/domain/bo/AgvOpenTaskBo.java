package com.ruoyi.wms.domain.bo;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import com.ruoyi.wms.domain.entity.AgvOpenTask;
import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = AgvOpenTask.class, reverseConvertGenerate = false)
public class AgvOpenTaskBo extends BaseEntity {

    @NotNull(message = "主键不能为空", groups = { EditGroup.class })
    private Long id;

    /**
     * 外部业务id outID
     */
    private String outId;

    /**
     * 调度系统任务编号（可选）
     */
    private String taskCode;

    /**
     * 任务类型，必填：01/05/10/12/13/18
     */
    @NotBlank(message = "任务类型不能为空", groups = { AddGroup.class })
    private String taskType;

    /**
     * 是否有序，默认 false
     */
    private String isOrder;

    /**
     * agv范围
     */
    private String agvRange;

    /**
     * 任务级别
     */
    private String level;

    /**
     * 被清空的外部业务id
     */
    private String clearOutId;

    /**
     * 作业点
     */
    @Valid
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<AgvTaskPoint> points = new ArrayList<>();

    private String status;
    private String agvCode;
    private String responseCode;
    private String responseMessage;
    private String requestPayload;
    private String lastResult;
    private String remark;

    @Data
    public static class AgvTaskPoint {
        @NotBlank(message = "作业序号不能为空")
        private String sn;

        @NotBlank(message = "作业编号不能为空")
        private String pointCode;

        @NotBlank(message = "作业类型不能为空")
        private String pointType;

        private String matCode;
    }

    /**
     * 仅用于列表查询，避免空指针
     */
    @JsonIgnore
    public List<AgvTaskPoint> getSafePoints() {
        return points == null ? new ArrayList<>() : points;
    }
}

