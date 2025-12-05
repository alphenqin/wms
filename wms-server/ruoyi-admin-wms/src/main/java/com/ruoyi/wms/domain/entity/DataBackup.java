package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;
import java.util.Date;

/**
 * 数据备份对象 wms_data_backup
 *
 * @author wms
 * @date 2024
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_data_backup")
public class DataBackup extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 备份编号
     */
    private String backupNo;

    /**
     * 备份名称
     */
    private String backupName;

    /**
     * 备份类型（1:全量备份 2:增量备份 3:指定表备份）
     */
    private Integer backupType;

    /**
     * 备份文件路径
     */
    private String filePath;

    /**
     * 文件大小（MB）
     */
    private Long fileSize;

    /**
     * 备份时间
     */
    private Date backupTime;

    /**
     * 备份状态（0:进行中 1:成功 2:失败）
     */
    private Integer status;

    /**
     * 错误信息
     */
    private String errorMsg;

    /**
     * 是否自动备份（0:否 1:是）
     */
    private Integer isAuto;

    /**
     * 备注
     */
    private String remark;
}

