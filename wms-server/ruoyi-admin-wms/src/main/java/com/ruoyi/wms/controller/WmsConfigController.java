package com.ruoyi.wms.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.excel.utils.ExcelUtil;
import com.ruoyi.common.idempotent.annotation.RepeatSubmit;
import com.ruoyi.common.log.annotation.Log;
import com.ruoyi.common.log.enums.BusinessType;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.common.web.core.BaseController;
import com.ruoyi.wms.service.WmsConfigService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.WmsConfigBo;
import com.ruoyi.wms.domain.vo.WmsConfigVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/config")
public class WmsConfigController extends BaseController {

    private final WmsConfigService wmsConfigService;

    @SaCheckPermission("wms:config:list")
    @GetMapping("/list")
    public TableDataInfo<WmsConfigVo> list(WmsConfigBo bo, PageQuery pageQuery) {
        return wmsConfigService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:config:list")
    @GetMapping("/listNoPage")
    public R<List<WmsConfigVo>> listNoPage(WmsConfigBo bo) {
        return R.ok(wmsConfigService.queryList(bo));
    }

    @SaCheckPermission("wms:config:list")
    @GetMapping("/group/{configGroup}")
    public R<List<WmsConfigVo>> getByGroup(@PathVariable String configGroup) {
        return R.ok(wmsConfigService.queryByGroup(configGroup));
    }

    @SaCheckPermission("wms:config:list")
    @GetMapping("/key/{configKey}")
    public R<WmsConfigVo> getByKey(@PathVariable String configKey) {
        return R.ok(wmsConfigService.queryByKey(configKey));
    }

    @SaCheckPermission("wms:config:export")
    @Log(title = "WMS配置", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(WmsConfigBo bo, HttpServletResponse response) {
        List<WmsConfigVo> list = wmsConfigService.queryList(bo);
        ExcelUtil.exportExcel(list, "WMS配置", WmsConfigVo.class, response);
    }

    @SaCheckPermission("wms:config:list")
    @GetMapping("/{id}")
    public R<WmsConfigVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(wmsConfigService.queryById(id));
    }

    @SaCheckPermission("wms:config:edit")
    @Log(title = "WMS配置", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody WmsConfigBo bo) {
        wmsConfigService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:config:edit")
    @Log(title = "WMS配置", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody WmsConfigBo bo) {
        wmsConfigService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:config:edit")
    @Log(title = "WMS配置", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        wmsConfigService.deleteById(id);
        return R.ok();
    }
}

