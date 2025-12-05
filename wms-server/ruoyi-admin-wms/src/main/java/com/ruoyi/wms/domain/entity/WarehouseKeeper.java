package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;
import java.util.Date;

/**
 * 库管员对象 wms_warehouse_keeper
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_warehouse_keeper")
public class WarehouseKeeper extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 库管员编号
     */
    private String keeperCode;

    /**
     * 库管员姓名
     */
    private String keeperName;

    /**
     * 用户ID（关联sys_user）
     */
    private Long userId;

    /**
     * 所属仓库ID
     */
    private Long warehouseId;

    /**
     * 岗位
     */
    private String post;

    /**
     * 入职日期
     */
    private Date joinDate;

    /**
     * 状态（0:正常 1:停用）
     */
    private String status;

    /**
     * 备注
     */
    private String remark;
}

