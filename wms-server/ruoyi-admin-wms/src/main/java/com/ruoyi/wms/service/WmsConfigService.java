package com.ruoyi.wms.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.WmsConfigBo;
import com.ruoyi.wms.domain.entity.WmsConfig;
import com.ruoyi.wms.domain.vo.WmsConfigVo;
import com.ruoyi.wms.mapper.WmsConfigMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * WMS配置Service业务层处理
 *
 * @author wms
 * @date 2024
 */
@RequiredArgsConstructor
@Service
public class WmsConfigService extends ServiceImpl<WmsConfigMapper, WmsConfig> {

    private final WmsConfigMapper wmsConfigMapper;

    public WmsConfigVo queryById(Long id) {
        return wmsConfigMapper.selectVoById(id);
    }

    public WmsConfigVo queryByKey(String configKey) {
        LambdaQueryWrapper<WmsConfig> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(WmsConfig::getConfigKey, configKey);
        WmsConfig config = wmsConfigMapper.selectOne(wrapper);
        return config != null ? MapstructUtils.convert(config, WmsConfigVo.class) : null;
    }

    /**
     * 获取布尔类型配置
     */
    public boolean getBooleanConfig(String configKey, boolean defaultValue) {
        WmsConfigVo config = queryByKey(configKey);
        if (config == null || StrUtil.isBlank(config.getConfigValue())) {
            return defaultValue;
        }
        String value = config.getConfigValue().trim();
        if (StrUtil.equalsAnyIgnoreCase(value, "true", "1", "yes", "y", "on")) {
            return true;
        }
        if (StrUtil.equalsAnyIgnoreCase(value, "false", "0", "no", "n", "off")) {
            return false;
        }
        return defaultValue;
    }

    /**
     * 根据配置分组查询
     */
    public List<WmsConfigVo> queryByGroup(String configGroup) {
        LambdaQueryWrapper<WmsConfig> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(StrUtil.isNotBlank(configGroup), WmsConfig::getConfigGroup, configGroup);
        wrapper.eq(WmsConfig::getStatus, "0"); // 只查询正常状态的配置
        return wmsConfigMapper.selectVoList(wrapper);
    }

    public TableDataInfo<WmsConfigVo> queryPageList(WmsConfigBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<WmsConfig> lqw = buildQueryWrapper(bo);
        Page<WmsConfigVo> result = wmsConfigMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<WmsConfigVo> queryList(WmsConfigBo bo) {
        LambdaQueryWrapper<WmsConfig> lqw = buildQueryWrapper(bo);
        return wmsConfigMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<WmsConfig> buildQueryWrapper(WmsConfigBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<WmsConfig> lqw = Wrappers.lambdaQuery();
        lqw.eq(StrUtil.isNotBlank(bo.getConfigKey()), WmsConfig::getConfigKey, bo.getConfigKey());
        lqw.eq(bo.getConfigType() != null, WmsConfig::getConfigType, bo.getConfigType());
        lqw.eq(StrUtil.isNotBlank(bo.getConfigGroup()), WmsConfig::getConfigGroup, bo.getConfigGroup());
        lqw.eq(StrUtil.isNotBlank(bo.getStatus()), WmsConfig::getStatus, bo.getStatus());
        return lqw;
    }

    @Transactional(rollbackFor = Exception.class)
    public void insertByBo(WmsConfigBo bo) {
        WmsConfig add = MapstructUtils.convert(bo, WmsConfig.class);
        if (add.getStatus() == null) {
            add.setStatus("0");
        }
        wmsConfigMapper.insert(add);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateByBo(WmsConfigBo bo) {
        WmsConfig update = MapstructUtils.convert(bo, WmsConfig.class);
        wmsConfigMapper.updateById(update);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteById(Long id) {
        wmsConfigMapper.deleteById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteByIds(Collection<Long> ids) {
        wmsConfigMapper.deleteBatchIds(ids);
    }
}

