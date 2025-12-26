package com.ruoyi.system.service;

import com.ruoyi.common.core.service.DictService;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.system.domain.bo.SysDictTypeBo;
import com.ruoyi.system.domain.vo.SysDictDataVo;
import com.ruoyi.system.domain.vo.SysDictTypeVo;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * 字典功能已关闭：返回空数据，避免调用字典数据表。
 */
@Service
public class SysDictTypeService implements DictService {

    public TableDataInfo<SysDictTypeVo> selectPageDictTypeList(SysDictTypeBo dictType, PageQuery pageQuery) {
        return TableDataInfo.build(Collections.emptyList());
    }

    public List<SysDictTypeVo> selectDictTypeList(SysDictTypeBo dictType) {
        return Collections.emptyList();
    }

    public List<SysDictTypeVo> selectDictTypeAll() {
        return Collections.emptyList();
    }

    public List<SysDictDataVo> selectDictDataByType(String dictType) {
        return Collections.emptyList();
    }

    public SysDictTypeVo selectDictTypeById(Long dictId) {
        return null;
    }

    public SysDictTypeVo selectDictTypeByType(String dictType) {
        return null;
    }

    public void deleteDictTypeByIds(Long[] dictIds) {
        // no-op
    }

    public void loadingDictCache() {
        // no-op
    }

    public void clearDictCache() {
        // no-op
    }

    public void resetDictCache() {
        // no-op
    }

    public List<SysDictDataVo> insertDictType(SysDictTypeBo bo) {
        return Collections.emptyList();
    }

    public List<SysDictDataVo> updateDictType(SysDictTypeBo bo) {
        return Collections.emptyList();
    }

    public boolean checkDictTypeUnique(SysDictTypeBo dict) {
        return true;
    }

    @Override
    public String getDictLabel(String dictType, String dictValue, String separator) {
        return "";
    }

    @Override
    public String getDictValue(String dictType, String dictLabel, String separator) {
        return "";
    }

    @Override
    public Map<String, String> getAllDictByDictType(String dictType) {
        return Collections.emptyMap();
    }
}
