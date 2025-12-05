package com.ruoyi.wms.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.constant.HttpStatus;
import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.BarcodeBo;
import com.ruoyi.wms.domain.entity.Barcode;
import com.ruoyi.wms.domain.vo.BarcodeVo;
import com.ruoyi.wms.mapper.BarcodeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * 条码Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class BarcodeService extends ServiceImpl<BarcodeMapper, Barcode> {

    private final BarcodeMapper barcodeMapper;

    public BarcodeVo queryById(Long id) {
        return barcodeMapper.selectVoById(id);
    }

    public BarcodeVo queryByBarcode(String barcode) {
        LambdaQueryWrapper<Barcode> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Barcode::getBarcode, barcode);
        Barcode barcodeEntity = barcodeMapper.selectOne(wrapper);
        return barcodeEntity != null ? MapstructUtils.convert(barcodeEntity, BarcodeVo.class) : null;
    }

    public TableDataInfo<BarcodeVo> queryPageList(BarcodeBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<Barcode> lqw = buildQueryWrapper(bo);
        Page<BarcodeVo> result = barcodeMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<BarcodeVo> queryList(BarcodeBo bo) {
        LambdaQueryWrapper<Barcode> lqw = buildQueryWrapper(bo);
        return barcodeMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<Barcode> buildQueryWrapper(BarcodeBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<Barcode> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getBarcode()), Barcode::getBarcode, bo.getBarcode());
        lqw.eq(bo.getBarcodeType() != null, Barcode::getBarcodeType, bo.getBarcodeType());
        lqw.eq(StrUtil.isNotBlank(bo.getObjectType()), Barcode::getObjectType, bo.getObjectType());
        lqw.eq(bo.getObjectId() != null, Barcode::getObjectId, bo.getObjectId());
        lqw.eq(StrUtil.isNotBlank(bo.getStatus()), Barcode::getStatus, bo.getStatus());
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(BarcodeBo bo) {
        validateBarcode(bo);
        Barcode add = MapstructUtils.convert(bo, Barcode.class);
        if (add.getStatus() == null) {
            add.setStatus("0");
        }
        barcodeMapper.insert(add);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(BarcodeBo bo) {
        validateBarcode(bo);
        Barcode update = MapstructUtils.convert(bo, Barcode.class);
        barcodeMapper.updateById(update);
    }

    private void validateBarcode(BarcodeBo barcode) {
        LambdaQueryWrapper<Barcode> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(Barcode::getBarcode, barcode.getBarcode());
        List<Barcode> barcodeList = barcodeMapper.selectList(queryWrapper);
        boolean validateResult = barcodeList.stream().anyMatch(
            it -> it.getBarcode().equals(barcode.getBarcode()) && !it.getId().equals(barcode.getId()));
        if (validateResult) {
            throw new ServiceException("条码编号重复", HttpStatus.CONFLICT);
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        barcodeMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        barcodeMapper.deleteBatchIds(ids);
    }
}

