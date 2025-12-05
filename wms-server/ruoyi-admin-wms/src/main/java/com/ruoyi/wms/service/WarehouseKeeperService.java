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
import com.ruoyi.wms.domain.bo.WarehouseKeeperBo;
import com.ruoyi.wms.domain.entity.WarehouseKeeper;
import com.ruoyi.wms.domain.vo.WarehouseKeeperVo;
import com.ruoyi.wms.mapper.WarehouseKeeperMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 库管员Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class WarehouseKeeperService extends ServiceImpl<WarehouseKeeperMapper, WarehouseKeeper> {

    private final WarehouseKeeperMapper warehouseKeeperMapper;

    public WarehouseKeeperVo queryById(Long id) {
        return warehouseKeeperMapper.selectVoById(id);
    }

    public TableDataInfo<WarehouseKeeperVo> queryPageList(WarehouseKeeperBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<WarehouseKeeper> lqw = buildQueryWrapper(bo);
        Page<WarehouseKeeperVo> result = warehouseKeeperMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<WarehouseKeeperVo> queryList(WarehouseKeeperBo bo) {
        LambdaQueryWrapper<WarehouseKeeper> lqw = buildQueryWrapper(bo);
        return warehouseKeeperMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<WarehouseKeeper> buildQueryWrapper(WarehouseKeeperBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<WarehouseKeeper> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getKeeperCode()), WarehouseKeeper::getKeeperCode, bo.getKeeperCode());
        lqw.like(StrUtil.isNotBlank(bo.getKeeperName()), WarehouseKeeper::getKeeperName, bo.getKeeperName());
        lqw.eq(bo.getUserId() != null, WarehouseKeeper::getUserId, bo.getUserId());
        lqw.eq(bo.getWarehouseId() != null, WarehouseKeeper::getWarehouseId, bo.getWarehouseId());
        lqw.eq(StrUtil.isNotBlank(bo.getStatus()), WarehouseKeeper::getStatus, bo.getStatus());
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(WarehouseKeeperBo bo) {
        validateKeeper(bo);
        WarehouseKeeper add = MapstructUtils.convert(bo, WarehouseKeeper.class);
        if (add.getStatus() == null) {
            add.setStatus("0");
        }
        warehouseKeeperMapper.insert(add);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(WarehouseKeeperBo bo) {
        validateKeeper(bo);
        WarehouseKeeper update = MapstructUtils.convert(bo, WarehouseKeeper.class);
        warehouseKeeperMapper.updateById(update);
    }

    private void validateKeeper(WarehouseKeeperBo keeper) {
        LambdaQueryWrapper<WarehouseKeeper> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.and(wrapper -> {
            wrapper.eq(StrUtil.isNotBlank(keeper.getKeeperCode()), WarehouseKeeper::getKeeperCode, keeper.getKeeperCode())
                    .or()
                    .eq(keeper.getUserId() != null, WarehouseKeeper::getUserId, keeper.getUserId());
        });
        List<WarehouseKeeper> keeperList = warehouseKeeperMapper.selectList(queryWrapper);
        boolean validateCodeResult = keeperList.stream().anyMatch(
            it -> Objects.equals(it.getKeeperCode(), keeper.getKeeperCode()) && !Objects.equals(it.getId(), keeper.getId()));
        Assert.isFalse(validateCodeResult, "库管员编号重复");
        boolean validateUserResult = keeperList.stream().anyMatch(
            it -> Objects.equals(it.getUserId(), keeper.getUserId()) && !Objects.equals(it.getId(), keeper.getId()));
        Assert.isFalse(validateUserResult, "用户已关联其他库管员");
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        warehouseKeeperMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        warehouseKeeperMapper.deleteBatchIds(ids);
    }
}

