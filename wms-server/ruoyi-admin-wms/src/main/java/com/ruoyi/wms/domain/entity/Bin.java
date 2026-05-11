package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;
import java.math.BigDecimal;

/**
 * 货位对象 wms_bin
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_bin")
public class Bin extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 货位编号（binCode）
     */
    private String binCode;

    /**
     * 货位名称
     */
    private String binName;

    /**
     * 所属仓库ID
     */
    private Long warehouseId;

    /**
     * 所属货区ID
     */
    private Long areaId;

    /**
     * 库位类型（1:小托盘 2:大托盘）
     */
    private Integer binType;

    /**
     * 温区（1:常温 2:冷藏 3:冷冻 4:其他）
     */
    private Integer temperatureZone;

    /**
     * 容量（单位：立方米或托盘数）
     */
    private BigDecimal capacity;

    /**
     * 当前占用容量
     */
    private BigDecimal usedCapacity;

    /**
     * 状态（0:空闲 1:占用 2:禁用 3:锁定-任务中）
     */
    private Integer status;

    /**
     * 库位状态（0:空库位 1:空托盘 2:满托盘）
     */
    private Integer storageStatus;

    /**
     * 满托盘绑定的出厂编号
     */
    private String boundFactoryNo;

    /**
     * 排序
     */
    private Long orderNum;

    /**
     * 备注
     */
    private String remark;
}

