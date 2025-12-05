package com.ruoyi.wms.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.PdaOperationBo;
import com.ruoyi.wms.domain.entity.PdaOperation;
import com.ruoyi.wms.domain.vo.PdaOperationVo;
import com.ruoyi.wms.mapper.PdaOperationMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * PDA操作Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class PdaOperationService extends ServiceImpl<PdaOperationMapper, PdaOperation> {

    private final PdaOperationMapper pdaOperationMapper;

    public PdaOperationVo queryById(Long id) {
        return pdaOperationMapper.selectVoById(id);
    }

    public TableDataInfo<PdaOperationVo> queryPageList(PdaOperationBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<PdaOperation> lqw = buildQueryWrapper(bo);
        Page<PdaOperationVo> result = pdaOperationMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<PdaOperationVo> queryList(PdaOperationBo bo) {
        LambdaQueryWrapper<PdaOperation> lqw = buildQueryWrapper(bo);
        return pdaOperationMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<PdaOperation> buildQueryWrapper(PdaOperationBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<PdaOperation> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getOperationNo()), PdaOperation::getOperationNo, bo.getOperationNo());
        lqw.eq(bo.getOperationType() != null, PdaOperation::getOperationType, bo.getOperationType());
        lqw.eq(StrUtil.isNotBlank(bo.getOperator()), PdaOperation::getOperator, bo.getOperator());
        lqw.eq(StrUtil.isNotBlank(bo.getPdaDeviceNo()), PdaOperation::getPdaDeviceNo, bo.getPdaDeviceNo());
        lqw.eq(StrUtil.isNotBlank(bo.getScannedCode()), PdaOperation::getScannedCode, bo.getScannedCode());
        lqw.eq(StrUtil.isNotBlank(bo.getBizOrderNo()), PdaOperation::getBizOrderNo, bo.getBizOrderNo());
        lqw.eq(bo.getResult() != null, PdaOperation::getResult, bo.getResult());
        lqw.orderByDesc(PdaOperation::getCreateTime);
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(PdaOperationBo bo) {
        PdaOperation add = MapstructUtils.convert(bo, PdaOperation.class);
        if (add.getOperationNo() == null) {
            add.setOperationNo(generateOperationNo());
        }
        pdaOperationMapper.insert(add);
    }

    private String generateOperationNo() {
        return "PDA" + System.currentTimeMillis();
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(PdaOperationBo bo) {
        PdaOperation update = MapstructUtils.convert(bo, PdaOperation.class);
        pdaOperationMapper.updateById(update);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        pdaOperationMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        pdaOperationMapper.deleteBatchIds(ids);
    }
}

