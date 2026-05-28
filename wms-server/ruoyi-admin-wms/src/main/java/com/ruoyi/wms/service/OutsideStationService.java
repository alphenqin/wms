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
import com.ruoyi.wms.domain.bo.OutsideStationBo;
import com.ruoyi.wms.domain.entity.OutsideStation;
import com.ruoyi.wms.domain.vo.OutsideStationVo;
import com.ruoyi.wms.mapper.OutsideStationMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Objects;

@RequiredArgsConstructor
@Service
public class OutsideStationService extends ServiceImpl<OutsideStationMapper, OutsideStation> {

    private final OutsideStationMapper outsideStationMapper;

    public OutsideStationVo queryById(Long id) {
        return outsideStationMapper.selectVoById(id);
    }

    public TableDataInfo<OutsideStationVo> queryPageList(OutsideStationBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<OutsideStation> lqw = buildQueryWrapper(bo);
        Page<OutsideStationVo> result = outsideStationMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<OutsideStationVo> queryList(OutsideStationBo bo) {
        LambdaQueryWrapper<OutsideStation> lqw = buildQueryWrapper(bo);
        return outsideStationMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<OutsideStation> buildQueryWrapper(OutsideStationBo bo) {
        LambdaQueryWrapper<OutsideStation> lqw = Wrappers.lambdaQuery();
        lqw.like(StrUtil.isNotBlank(bo.getStationCode()), OutsideStation::getStationCode, bo.getStationCode());
        lqw.eq(StrUtil.isNotBlank(bo.getPalletType()), OutsideStation::getPalletType, bo.getPalletType());
        lqw.eq(StrUtil.isNotBlank(bo.getStatus()), OutsideStation::getStatus, bo.getStatus());
        lqw.eq(StrUtil.isNotBlank(bo.getSourceType()), OutsideStation::getSourceType, bo.getSourceType());
        lqw.orderByAsc(OutsideStation::getStationCode);
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(OutsideStationBo bo) {
        validateOutsideStation(bo);
        OutsideStation add = MapstructUtils.convert(bo, OutsideStation.class);
        if (StrUtil.isBlank(add.getStatus())) {
            add.setStatus("IDLE");
        }
        outsideStationMapper.insert(add);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(OutsideStationBo bo) {
        validateOutsideStation(bo);
        OutsideStation update = MapstructUtils.convert(bo, OutsideStation.class);
        outsideStationMapper.updateById(update);
    }

    private void validateOutsideStation(OutsideStationBo bo) {
        LambdaQueryWrapper<OutsideStation> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(OutsideStation::getStationCode, bo.getStationCode());
        List<OutsideStation> stationList = outsideStationMapper.selectList(wrapper);
        boolean duplicateCode = stationList.stream().anyMatch(
            it -> Objects.equals(it.getStationCode(), bo.getStationCode()) && !Objects.equals(it.getId(), bo.getId()));
        Assert.isFalse(duplicateCode, "库外站点重复");
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        outsideStationMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        outsideStationMapper.deleteBatchIds(ids);
    }
}
