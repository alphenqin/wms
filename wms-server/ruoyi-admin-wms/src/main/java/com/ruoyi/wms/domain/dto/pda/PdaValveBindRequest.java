package com.ruoyi.wms.domain.dto.pda;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * PDA阀门绑定请求DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaValveBindRequest {

    /**
     * 出厂编号
     */
    @NotBlank(message = "出厂编号不能为空")
    private String valveNo;

    /**
     * 物料编码，对接AGV调度系统使用
     */
    @NotBlank(message = "物料编码不能为空")
    private String matCode;

    /**
     * 厂家名称（可选）
     */
    private String vendorName;

    /**
     * 入库日期（yyyy-MM-dd格式）
     */
    @NotBlank(message = "入库日期不能为空")
    private String inboundDate;

    /**
     * 托盘号
     */
    @NotBlank(message = "托盘号不能为空")
    private String palletNo;

    /**
     * 库位号
     */
    @NotBlank(message = "库位号不能为空")
    private String binCode;

    /**
     * PDA设备编号（可选）
     */
    private String deviceCode;
}

