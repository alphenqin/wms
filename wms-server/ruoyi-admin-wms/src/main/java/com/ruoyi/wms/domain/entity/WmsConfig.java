package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

/**
 * WMS系统配置对象 wms_config
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_config")
public class WmsConfig extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 配置键
     */
    private String configKey;

    /**
     * 配置值
     */
    private String configValue;

    /**
     * 配置类型（1:业务参数 2:规则配置 3:系统配置 4:PDA配置 5:AGV配置）
     */
    private Integer configType;

    /**
     * 配置分组（warehouse/pda/agv/system等）
     */
    private String configGroup;

    /**
     * 配置描述
     */
    private String configDesc;

    /**
     * 状态（0:正常 1:停用）
     */
    private String status;

    /**
     * 备注
     */
    private String remark;
}

