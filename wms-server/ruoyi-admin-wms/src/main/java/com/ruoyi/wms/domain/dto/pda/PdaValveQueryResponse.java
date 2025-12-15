package com.ruoyi.wms.domain.dto.pda;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

/**
 * PDA阀门查询响应DTO
 *
 * @author wms
 * @date 2025-01-15
 */
@Data
public class PdaValveQueryResponse implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 数据列表
     */
    private List<PdaValveInfo> list;

    /**
     * 总记录数
     */
    private Long total;

    /**
     * 当前页码
     */
    private Integer pageNum;

    /**
     * 每页大小
     */
    private Integer pageSize;
}

