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
import com.ruoyi.wms.domain.entity.Bin;
import com.ruoyi.wms.domain.entity.Pallet;
import com.ruoyi.wms.domain.entity.PalletType;
import com.ruoyi.wms.domain.vo.PalletVo;
import com.ruoyi.wms.mapper.BinMapper;
import com.ruoyi.wms.mapper.PalletMapper;
import com.ruoyi.wms.mapper.PalletTypeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

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
    private final PalletTypeMapper palletTypeMapper;

    public PalletVo queryById(Long id) {
        PalletVo vo = palletMapper.selectVoById(id);
        fillPalletTypeName(vo);
        return vo;
    }

    public PalletVo queryByPalletCode(String palletCode) {
        LambdaQueryWrapper<Pallet> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Pallet::getPalletCode, palletCode);
        Pallet pallet = palletMapper.selectOne(wrapper);
        PalletVo vo = pallet != null ? MapstructUtils.convert(pallet, PalletVo.class) : null;
        fillPalletTypeName(vo);
        return vo;
    }

    public PalletVo queryByOutsideSite(String outsideSite) {
        String site = StrUtil.trimToNull(outsideSite);
        if (site == null) {
            return null;
        }
        LambdaQueryWrapper<Pallet> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Pallet::getOutsideSite, site);
        wrapper.eq(Pallet::getIsEmpty, 1);
        wrapper.eq(Pallet::getIsBound, 0);
        wrapper.eq(Pallet::getStatus, "0");
        Pallet pallet = palletMapper.selectOne(wrapper);
        PalletVo vo = pallet != null ? MapstructUtils.convert(pallet, PalletVo.class) : null;
        fillPalletTypeName(vo);
        return vo;
    }

    public TableDataInfo<PalletVo> queryPageList(PalletBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<Pallet> lqw = buildQueryWrapper(bo);
        Page<PalletVo> result = palletMapper.selectVoPage(pageQuery.build(), lqw);
        fillPalletTypeName(result.getRecords());
        return TableDataInfo.build(result);
    }

    public List<PalletVo> queryList(PalletBo bo) {
        LambdaQueryWrapper<Pallet> lqw = buildQueryWrapper(bo);
        List<PalletVo> list = palletMapper.selectVoList(lqw);
        fillPalletTypeName(list);
        return list;
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
        List<PalletVo> list = palletMapper.selectVoList(lqw);
        fillPalletTypeName(list);
        return list;
    }

    /**
     * 查询指定类型、从指定编号开始的首个可用空托盘。
     */
    public PalletVo queryFirstAvailableByTypeFromCode(Long palletTypeId, String startCode) {
        return queryFirstAvailableByTypeFromCodeAndPreferredLevel(palletTypeId, startCode, null, (String) null);
    }

    /**
     * 查询指定类型的首个可用空托盘，优先选择指定层数。
     */
    public PalletVo queryFirstAvailableByTypeFromCodeAndPreferredLevel(Long palletTypeId, String startCode,
                                                                       Integer preferredLevel, String excludeBinCode) {
        Set<String> excludeBinCodes = StrUtil.isBlank(excludeBinCode)
            ? Set.of()
            : Set.of(excludeBinCode.trim());
        return queryFirstAvailableByTypeFromCodeAndPreferredLevel(palletTypeId, startCode, preferredLevel, excludeBinCodes);
    }

    /**
     * 查询指定类型的首个可用空托盘，优先选择指定层数，并排除指定库位。
     */
    public PalletVo queryFirstAvailableByTypeFromCodeAndPreferredLevel(Long palletTypeId, String startCode,
                                                                       Integer preferredLevel, Collection<String> excludeBinCodes) {
        return queryFirstAvailableByTypeFromCodeAndPreferredLevel(palletTypeId, startCode, preferredLevel, null, excludeBinCodes);
    }

    /**
     * 查询指定类型的首个可用空托盘，优先同排，再从指定排开始按排号轮转选择。
     */
    public PalletVo queryFirstAvailableByTypeFromCodeAndPreferredLevel(Long palletTypeId, String startCode,
                                                                       Integer preferredLevel, String preferredBinCode,
                                                                       Collection<String> excludeBinCodes) {
        if (palletTypeId == null) {
            return null;
        }
        LambdaQueryWrapper<Pallet> lqw = Wrappers.lambdaQuery();
        lqw.eq(Pallet::getPalletTypeId, palletTypeId);
        lqw.isNotNull(Pallet::getCurrentBinCode);
        lqw.ne(Pallet::getCurrentBinCode, "");
        List<Pallet> pallets = palletMapper.selectList(lqw);
        Set<String> normalizedExcludeBinCodes = excludeBinCodes == null ? Set.of() : excludeBinCodes.stream()
            .map(StrUtil::trimToNull)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
        if (!normalizedExcludeBinCodes.isEmpty()) {
            pallets = pallets.stream()
                .filter(pallet -> !normalizedExcludeBinCodes.contains(StrUtil.trimToNull(pallet.getCurrentBinCode())))
                .collect(Collectors.toList());
        }
        pallets = pallets.stream()
            .filter(this::isLocatedOnEmptyPalletBin)
            .sorted(emptyPalletBinComparator(preferredLevel, preferredBinCode))
            .collect(Collectors.toList());
        Pallet pallet = pallets.isEmpty() ? null : pallets.get(0);
        PalletVo vo = pallet != null ? MapstructUtils.convert(pallet, PalletVo.class) : null;
        fillPalletTypeName(vo);
        return vo;
    }

    private Comparator<Pallet> emptyPalletBinComparator(Integer preferredLevel, String preferredBinCode) {
        Integer preferredRow = extractBinRow(preferredBinCode);
        Integer preferredColumn = extractBinColumn(preferredBinCode);
        return Comparator
            .comparingInt((Pallet pallet) -> rowPriority(pallet.getCurrentBinCode(), preferredRow))
            .thenComparingInt(pallet -> levelPriority(pallet.getCurrentBinCode(), preferredLevel))
            .thenComparingInt(pallet -> columnPriority(pallet.getCurrentBinCode(), preferredColumn))
            .thenComparingInt(pallet -> nullLast(extractBinLevel(pallet.getCurrentBinCode())))
            .thenComparing(pallet -> defaultString(pallet.getCurrentBinCode()))
            .thenComparingLong(pallet -> pallet.getId() == null ? Long.MAX_VALUE : pallet.getId());
    }

    private int levelPriority(String binCode, Integer preferredLevel) {
        Integer level = extractBinLevel(binCode);
        if (preferredLevel == null || level == null) {
            return nullLast(level);
        }
        return Objects.equals(level, preferredLevel) ? 0 : 10000 + level;
    }

    private int rowPriority(String binCode, Integer preferredRow) {
        Integer row = extractBinRow(binCode);
        if (preferredRow == null || row == null) {
            return nullLast(row);
        }
        return row >= preferredRow ? row - preferredRow : 10000 + row;
    }

    private int columnPriority(String binCode, Integer preferredColumn) {
        Integer column = extractBinColumn(binCode);
        if (preferredColumn == null || column == null) {
            return nullLast(column);
        }
        int distance = Math.abs(column - preferredColumn);
        int sidePriority = column <= preferredColumn ? 0 : 1;
        return distance * 10 + sidePriority;
    }

    private int nullLast(Integer value) {
        return value == null ? Integer.MAX_VALUE : value;
    }

    private String defaultString(String value) {
        return value == null ? "" : value;
    }

    private boolean isLocatedOnEmptyPalletBin(Pallet pallet) {
        if (pallet == null || StrUtil.isBlank(pallet.getCurrentBinCode())) {
            return false;
        }
        Bin bin = binMapper.selectOne(Wrappers.<Bin>lambdaQuery()
            .eq(Bin::getBinCode, StrUtil.trim(pallet.getCurrentBinCode())));
        return bin != null
            && Objects.equals(bin.getStorageStatus(), BinService.STORAGE_STATUS_EMPTY_PALLET)
            && !Objects.equals(bin.getStatus(), 2);
    }

    private Integer extractBinRow(String binCode) {
        if (StrUtil.isBlank(binCode)) {
            return null;
        }
        String[] parts = binCode.trim().split("-");
        if (parts.length < 3) {
            return null;
        }
        String rowPart = parts[0];
        if (rowPart.length() < 2) {
            return null;
        }
        try {
            return Integer.parseInt(rowPart.substring(1));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer extractBinColumn(String binCode) {
        if (StrUtil.isBlank(binCode)) {
            return null;
        }
        String[] parts = binCode.trim().split("-");
        if (parts.length < 3) {
            return null;
        }
        try {
            return Integer.parseInt(parts[1]);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer extractBinLevel(String binCode) {
        if (StrUtil.isBlank(binCode)) {
            return null;
        }
        String[] parts = binCode.trim().split("-");
        if (parts.length < 3) {
            return null;
        }
        try {
            return Integer.parseInt(parts[parts.length - 1]);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private LambdaQueryWrapper<Pallet> buildQueryWrapper(PalletBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<Pallet> lqw = Wrappers.lambdaQuery();
        String palletCode = StrUtil.trimToNull(bo.getPalletCode());
        lqw.like(palletCode != null, Pallet::getPalletCode, palletCode);
        lqw.eq(bo.getPalletTypeId() != null, Pallet::getPalletTypeId, bo.getPalletTypeId());
        lqw.eq(bo.getCurrentBinId() != null, Pallet::getCurrentBinId, bo.getCurrentBinId());
        lqw.like(StrUtil.isNotBlank(bo.getCurrentBinCode()), Pallet::getCurrentBinCode, bo.getCurrentBinCode());
        lqw.like(StrUtil.isNotBlank(bo.getOutsideSite()), Pallet::getOutsideSite, StrUtil.trim(bo.getOutsideSite()));
        lqw.eq(bo.getIsEmpty() != null, Pallet::getIsEmpty, bo.getIsEmpty());
        lqw.eq(bo.getIsBound() != null, Pallet::getIsBound, bo.getIsBound());
        lqw.eq(StrUtil.isNotBlank(bo.getStatus()), Pallet::getStatus, bo.getStatus());
        lqw.orderByAsc(Pallet::getPalletCode);
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
     * 更新托盘位置和库外站点
     */
    @Transactional(rollbackFor = Exception.class)
    public void updatePalletLocationOutsideSite(Long palletId, Long binId, String binCode, String outsideSite) {
        Pallet pallet = palletMapper.selectById(palletId);
        if (pallet == null) {
            throw new ServiceException("托盘不存在");
        }
        pallet.setCurrentBinId(binId);
        pallet.setCurrentBinCode(binCode);
        pallet.setOutsideSite(StrUtil.trimToNull(outsideSite));
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

    private void fillPalletTypeName(PalletVo vo) {
        if (vo == null || vo.getPalletTypeId() == null) {
            return;
        }
        PalletType type = palletTypeMapper.selectById(vo.getPalletTypeId());
        if (type != null) {
            vo.setPalletTypeName(type.getTypeName());
        }
    }

    private void fillPalletTypeName(List<PalletVo> list) {
        if (list == null || list.isEmpty()) {
            return;
        }
        Set<Long> typeIds = list.stream()
            .map(PalletVo::getPalletTypeId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
        if (typeIds.isEmpty()) {
            return;
        }
        Map<Long, String> typeNameMap = palletTypeMapper.selectList(Wrappers.<PalletType>lambdaQuery()
                .in(PalletType::getId, typeIds))
            .stream()
            .collect(Collectors.toMap(PalletType::getId, PalletType::getTypeName, (a, b) -> a));
        for (PalletVo vo : list) {
            if (vo.getPalletTypeId() != null) {
                vo.setPalletTypeName(typeNameMap.get(vo.getPalletTypeId()));
            }
        }
    }
}

