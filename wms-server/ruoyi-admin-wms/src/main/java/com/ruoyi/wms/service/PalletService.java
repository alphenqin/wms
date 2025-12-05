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
import com.ruoyi.wms.domain.bo.PalletBo;
import com.ruoyi.wms.domain.entity.Pallet;
import com.ruoyi.wms.domain.vo.PalletVo;
import com.ruoyi.wms.mapper.BinMapper;
import com.ruoyi.wms.mapper.PalletMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 托盘Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class PalletService extends ServiceImpl<PalletMapper, Pallet> {

    private final PalletMapper palletMapper;
    private final BinMapper binMapper;

    public PalletVo queryById(Long id) {
        return palletMapper.selectVoById(id);
    }

    public PalletVo queryByPalletCode(String palletCode) {
        LambdaQueryWrapper<Pallet> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Pallet::getPalletCode, palletCode);
        Pallet pallet = palletMapper.selectOne(wrapper);
        return pallet != null ? MapstructUtils.convert(pallet, PalletVo.class) : null;
    }

    public TableDataInfo<PalletVo> queryPageList(PalletBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<Pallet> lqw = buildQueryWrapper(bo);
        Page<PalletVo> result = palletMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<PalletVo> queryList(PalletBo bo) {
        LambdaQueryWrapper<Pallet> lqw = buildQueryWrapper(bo);
        return palletMapper.selectVoList(lqw);
    }

    /**
     * 查询空托盘列表
     */
    public List<PalletVo> queryEmptyPallets(Long warehouseId) {
        LambdaQueryWrapper<Pallet> lqw = Wrappers.lambdaQuery();
        lqw.eq(Pallet::getIsEmpty, 1); // 1:是空托
        lqw.eq(StrUtil.isNotBlank("0"), Pallet::getStatus, "0"); // 0:正常
        if (warehouseId != null) {
            // 可以通过currentBinId关联查询仓库
        }
        return palletMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<Pallet> buildQueryWrapper(PalletBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<Pallet> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getPalletCode()), Pallet::getPalletCode, bo.getPalletCode());
        lqw.eq(bo.getPalletTypeId() != null, Pallet::getPalletTypeId, bo.getPalletTypeId());
        lqw.eq(bo.getCurrentBinId() != null, Pallet::getCurrentBinId, bo.getCurrentBinId());
        lqw.eq(bo.getIsEmpty() != null, Pallet::getIsEmpty, bo.getIsEmpty());
        lqw.eq(bo.getIsBound() != null, Pallet::getIsBound, bo.getIsBound());
        lqw.eq(StrUtil.isNotBlank(bo.getStatus()), Pallet::getStatus, bo.getStatus());
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(PalletBo bo) {
        validatePalletCode(bo);
        Pallet add = MapstructUtils.convert(bo, Pallet.class);
        if (add.getIsEmpty() == null) {
            add.setIsEmpty(1); // 默认空托
        }
        if (add.getIsBound() == null) {
            add.setIsBound(0); // 默认未绑定
        }
        if (add.getStatus() == null) {
            add.setStatus("0"); // 默认正常
        }
        palletMapper.insert(add);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(PalletBo bo) {
        validatePalletCode(bo);
        Pallet update = MapstructUtils.convert(bo, Pallet.class);
        palletMapper.updateById(update);
    }

    private void validatePalletCode(PalletBo pallet) {
        LambdaQueryWrapper<Pallet> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(Pallet::getPalletCode, pallet.getPalletCode());
        List<Pallet> palletList = palletMapper.selectList(queryWrapper);
        boolean validateCodeResult = palletList.stream().anyMatch(
            it -> Objects.equals(it.getPalletCode(), pallet.getPalletCode()) && !Objects.equals(it.getId(), pallet.getId()));
        if (validateCodeResult) {
            throw new ServiceException("托盘编号重复", HttpStatus.CONFLICT);
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        Pallet pallet = palletMapper.selectById(id);
        if (pallet != null && pallet.getIsBound() != null && pallet.getIsBound() == 1) {
            throw new ServiceException("删除失败", HttpStatus.CONFLICT, "该托盘已绑定物料，无法删除！");
        }
        palletMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        for (Long id : ids) {
            deleteById(id);
        }
    }

    /**
     * 更新托盘货位信息
     */
    @Transactional(rollbackFor = Exception.class)
    public void updatePalletBin(Long palletId, Long binId, String binCode) {
        Pallet pallet = palletMapper.selectById(palletId);
        if (pallet == null) {
            throw new ServiceException("托盘不存在");
        }
        pallet.setCurrentBinId(binId);
        pallet.setCurrentBinCode(binCode);
        palletMapper.updateById(pallet);
    }

    /**
     * 绑定物料
     */
    @Transactional(rollbackFor = Exception.class)
    public void bindMaterial(Long palletId) {
        Pallet pallet = palletMapper.selectById(palletId);
        if (pallet == null) {
            throw new ServiceException("托盘不存在");
        }
        pallet.setIsBound(1);
        pallet.setIsEmpty(0);
        palletMapper.updateById(pallet);
    }

    /**
     * 解绑物料
     */
    @Transactional(rollbackFor = Exception.class)
    public void unbindMaterial(Long palletId) {
        Pallet pallet = palletMapper.selectById(palletId);
        if (pallet == null) {
            throw new ServiceException("托盘不存在");
        }
        pallet.setIsBound(0);
        pallet.setIsEmpty(1);
        palletMapper.updateById(pallet);
    }
}

