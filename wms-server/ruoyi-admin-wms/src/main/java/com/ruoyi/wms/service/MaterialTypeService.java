package com.ruoyi.wms.service;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.lang.Assert;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.MaterialTypeBo;
import com.ruoyi.wms.domain.entity.MaterialType;
import com.ruoyi.wms.domain.vo.MaterialTypeVo;
import com.ruoyi.wms.mapper.MaterialTypeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 物料类型Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class MaterialTypeService extends ServiceImpl<MaterialTypeMapper, MaterialType> {

    private final MaterialTypeMapper materialTypeMapper;

    public MaterialTypeVo queryById(Long id) {
        return materialTypeMapper.selectVoById(id);
    }

    public TableDataInfo<MaterialTypeVo> queryPageList(MaterialTypeBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<MaterialType> lqw = buildQueryWrapper(bo);
        Page<MaterialTypeVo> result = materialTypeMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<MaterialTypeVo> queryList(MaterialTypeBo bo) {
        LambdaQueryWrapper<MaterialType> lqw = buildQueryWrapper(bo);
        return materialTypeMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<MaterialType> buildQueryWrapper(MaterialTypeBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<MaterialType> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getTypeCode()), MaterialType::getTypeCode, bo.getTypeCode());
        lqw.like(StrUtil.isNotBlank(bo.getTypeName()), MaterialType::getTypeName, bo.getTypeName());
        lqw.eq(StrUtil.isNotBlank(bo.getStatus()), MaterialType::getStatus, bo.getStatus());
        lqw.orderByAsc(MaterialType::getOrderNum);
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(MaterialTypeBo bo) {
        validateMaterialType(bo);
        MaterialType add = MapstructUtils.convert(bo, MaterialType.class);
        add.setOrderNum(this.getNextOrderNum());
        if (add.getStatus() == null) {
            add.setStatus("0");
        }
        materialTypeMapper.insert(add);
    }

    private Long getNextOrderNum() {
        LambdaQueryWrapper<MaterialType> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(MaterialType::getOrderNum);
        wrapper.last("limit 1");
        MaterialType type = materialTypeMapper.selectOne(wrapper);
        return type == null ? 0L : type.getOrderNum() + 1;
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(MaterialTypeBo bo) {
        validateMaterialType(bo);
        MaterialType update = MapstructUtils.convert(bo, MaterialType.class);
        materialTypeMapper.updateById(update);
    }

    private void validateMaterialType(MaterialTypeBo type) {
        LambdaQueryWrapper<MaterialType> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.and(wrapper -> {
            wrapper.eq(StrUtil.isNotBlank(type.getTypeCode()), MaterialType::getTypeCode, type.getTypeCode())
                    .or()
                    .eq(MaterialType::getTypeName, type.getTypeName());
        });
        List<MaterialType> typeList = materialTypeMapper.selectList(queryWrapper);
        boolean validateNameResult = typeList.stream().anyMatch(
            it -> Objects.equals(it.getTypeName(), type.getTypeName()) && !Objects.equals(it.getId(), type.getId()));
        Assert.isFalse(validateNameResult, "物料类型名称重复");
        boolean validateCodeResult = typeList.stream().anyMatch(
            it -> Objects.equals(it.getTypeCode(), type.getTypeCode()) && !Objects.equals(it.getId(), type.getId()));
        Assert.isFalse(validateCodeResult, "物料类型编号重复");
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        materialTypeMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        materialTypeMapper.deleteBatchIds(ids);
    }
}

