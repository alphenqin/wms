package com.ruoyi.wms.service;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.lang.Assert;
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
import com.ruoyi.wms.domain.bo.AreaBo;
import com.ruoyi.wms.domain.entity.Area;
import com.ruoyi.wms.domain.vo.AreaVo;
import com.ruoyi.wms.mapper.AreaMapper;
import com.ruoyi.wms.mapper.BinMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 货区Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class AreaService extends ServiceImpl<AreaMapper, Area> {

    private final AreaMapper areaMapper;
    private final BinMapper binMapper;

    /**
     * 查询货区
     */
    public AreaVo queryById(Long id) {
        AreaVo vo = areaMapper.selectVoById(id);
        // 填充仓库名称
        if (vo != null && vo.getWarehouseId() != null) {
            // 这里可以调用WarehouseService获取仓库名称，暂时先不实现
        }
        return vo;
    }

    /**
     * 查询货区列表
     */
    public TableDataInfo<AreaVo> queryPageList(AreaBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<Area> lqw = buildQueryWrapper(bo);
        Page<AreaVo> result = areaMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    /**
     * 查询货区列表
     */
    public List<AreaVo> queryList(AreaBo bo) {
        LambdaQueryWrapper<Area> lqw = buildQueryWrapper(bo);
        return areaMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<Area> buildQueryWrapper(AreaBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<Area> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getAreaCode()), Area::getAreaCode, bo.getAreaCode());
        lqw.like(StrUtil.isNotBlank(bo.getAreaName()), Area::getAreaName, bo.getAreaName());
        lqw.eq(bo.getWarehouseId() != null, Area::getWarehouseId, bo.getWarehouseId());
        lqw.eq(bo.getAreaType() != null, Area::getAreaType, bo.getAreaType());
        lqw.eq(StrUtil.isNotBlank(bo.getStatus()), Area::getStatus, bo.getStatus());
        lqw.orderByAsc(Area::getOrderNum);
        return lqw;
    }

    /**
     * 新增货区
     */
    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(AreaBo bo) {
        validateAreaNameAndCode(bo);
        Area add = MapstructUtils.convert(bo, Area.class);
        add.setOrderNum(this.getNextOrderNum(bo.getWarehouseId()));
        if (add.getStatus() == null) {
            add.setStatus("0"); // 默认正常
        }
        areaMapper.insert(add);
    }

    private Long getNextOrderNum(Long warehouseId) {
        LambdaQueryWrapper<Area> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(warehouseId != null, Area::getWarehouseId, warehouseId);
        wrapper.orderByDesc(Area::getOrderNum);
        wrapper.last("limit 1");
        Area area = areaMapper.selectOne(wrapper);
        return area == null ? 0L : area.getOrderNum() + 1;
    }

    /**
     * 修改货区
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(AreaBo bo) {
        validateAreaNameAndCode(bo);
        Area update = MapstructUtils.convert(bo, Area.class);
        areaMapper.updateById(update);
    }

    private void validateAreaNameAndCode(AreaBo area) {
        LambdaQueryWrapper<Area> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(Area::getWarehouseId, area.getWarehouseId());
        queryWrapper.and(wrapper -> {
            wrapper.eq(Area::getAreaName, area.getAreaName())
                    .or()
                    .eq(StrUtil.isNotBlank(area.getAreaCode()), Area::getAreaCode, area.getAreaCode());
        });
        List<Area> areaList = areaMapper.selectList(queryWrapper);
        boolean validateNameResult = areaList.stream().anyMatch(
            it -> Objects.equals(it.getAreaName(), area.getAreaName()) && !Objects.equals(it.getId(), area.getId()));
        Assert.isFalse(validateNameResult, "货区名称重复");
        boolean validateCodeResult = areaList.stream().anyMatch(
            it -> Objects.equals(it.getAreaCode(), area.getAreaCode()) && !Objects.equals(it.getId(), area.getId()));
        Assert.isFalse(validateCodeResult, "货区编号重复");
    }

    /**
     * 删除货区
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        validIdBeforeDelete(id);
        areaMapper.deleteById(id);
    }

    private void validIdBeforeDelete(Long id) {
        // 检查是否有货位关联
        LambdaQueryWrapper<com.ruoyi.wms.domain.entity.Bin> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(com.ruoyi.wms.domain.entity.Bin::getAreaId, id);
        long count = binMapper.selectCount(wrapper);
        if (count > 0) {
            throw new ServiceException("删除失败", HttpStatus.CONFLICT, "该货区下存在货位，无法删除！");
        }
    }

    /**
     * 批量删除货区
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        for (Long id : ids) {
            validIdBeforeDelete(id);
        }
        areaMapper.deleteBatchIds(ids);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateOrderNum(List<AreaBo> tree) {
        if (CollUtil.isEmpty(tree)) {
            return;
        }
        List<Area> updateList = MapstructUtils.convert(tree, Area.class);
        for (int i = 0; i < updateList.size(); i++) {
            updateList.get(i).setOrderNum((long) i);
        }
        saveOrUpdateBatch(updateList);
    }
}

