package com.ruoyi.wms.service;

import cn.hutool.core.lang.Assert;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.PalletTypeBo;
import com.ruoyi.wms.domain.entity.PalletType;
import com.ruoyi.wms.domain.vo.PalletTypeVo;
import com.ruoyi.wms.mapper.PalletTypeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 托盘类型Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class PalletTypeService extends ServiceImpl<PalletTypeMapper, PalletType> {

    private final PalletTypeMapper palletTypeMapper;

    public PalletTypeVo queryById(Long id) {
        return palletTypeMapper.selectVoById(id);
    }

    public PalletTypeVo queryByTypeCode(String typeCode) {
        LambdaQueryWrapper<PalletType> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(PalletType::getTypeCode, typeCode);
        PalletType type = palletTypeMapper.selectOne(wrapper);
        return type != null ? MapstructUtils.convert(type, PalletTypeVo.class) : null;
    }

    public TableDataInfo<PalletTypeVo> queryPageList(PalletTypeBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<PalletType> lqw = buildQueryWrapper(bo);
        Page<PalletTypeVo> result = palletTypeMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<PalletTypeVo> queryList(PalletTypeBo bo) {
        LambdaQueryWrapper<PalletType> lqw = buildQueryWrapper(bo);
        return palletTypeMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<PalletType> buildQueryWrapper(PalletTypeBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<PalletType> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getTypeCode()), PalletType::getTypeCode, bo.getTypeCode());
        lqw.like(StrUtil.isNotBlank(bo.getTypeName()), PalletType::getTypeName, bo.getTypeName());
        lqw.eq(StrUtil.isNotBlank(bo.getStatus()), PalletType::getStatus, bo.getStatus());
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(PalletTypeBo bo) {
        validatePalletType(bo);
        PalletType add = MapstructUtils.convert(bo, PalletType.class);
        if (add.getStatus() == null) {
            add.setStatus("0");
        }
        palletTypeMapper.insert(add);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(PalletTypeBo bo) {
        validatePalletType(bo);
        PalletType update = MapstructUtils.convert(bo, PalletType.class);
        palletTypeMapper.updateById(update);
    }

    private void validatePalletType(PalletTypeBo type) {
        LambdaQueryWrapper<PalletType> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.and(wrapper -> {
            wrapper.eq(PalletType::getTypeCode, type.getTypeCode())
                    .or()
                    .eq(StrUtil.isNotBlank(type.getTypeName()), PalletType::getTypeName, type.getTypeName());
        });
        List<PalletType> typeList = palletTypeMapper.selectList(queryWrapper);
        boolean validateCodeResult = typeList.stream().anyMatch(
            it -> Objects.equals(it.getTypeCode(), type.getTypeCode()) && !Objects.equals(it.getId(), type.getId()));
        Assert.isFalse(validateCodeResult, "托盘类型编号重复");
        boolean validateNameResult = typeList.stream().anyMatch(
            it -> Objects.equals(it.getTypeName(), type.getTypeName()) && !Objects.equals(it.getId(), type.getId()));
        Assert.isFalse(validateNameResult, "托盘类型名称重复");
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        // 检查是否有托盘使用此类型
        // TODO: 添加托盘关联检查
        palletTypeMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        palletTypeMapper.deleteBatchIds(ids);
    }
}

