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
import com.ruoyi.wms.service.PalletTypeService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.PalletTypeBo;
import com.ruoyi.wms.domain.vo.PalletTypeVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/palletType")
public class PalletTypeController extends BaseController {

    private final PalletTypeService palletTypeService;

    @SaCheckPermission("wms:palletType:list")
    @GetMapping("/list")
    public TableDataInfo<PalletTypeVo> list(PalletTypeBo bo, PageQuery pageQuery) {
        return palletTypeService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:palletType:list")
    @GetMapping("/listNoPage")
    public R<List<PalletTypeVo>> listNoPage(PalletTypeBo bo) {
        return R.ok(palletTypeService.queryList(bo));
    }

    @SaCheckPermission("wms:palletType:list")
    @GetMapping("/code/{typeCode}")
    public R<PalletTypeVo> getByTypeCode(@PathVariable String typeCode) {
        return R.ok(palletTypeService.queryByTypeCode(typeCode));
    }

    @SaCheckPermission("wms:palletType:export")
    @Log(title = "托盘类型", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(PalletTypeBo bo, HttpServletResponse response) {
        List<PalletTypeVo> list = palletTypeService.queryList(bo);
        ExcelUtil.exportExcel(list, "托盘类型", PalletTypeVo.class, response);
    }

    @SaCheckPermission("wms:palletType:list")
    @GetMapping("/{id}")
    public R<PalletTypeVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(palletTypeService.queryById(id));
    }

    @SaCheckPermission("wms:palletType:edit")
    @Log(title = "托盘类型", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody PalletTypeBo bo) {
        palletTypeService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:palletType:edit")
    @Log(title = "托盘类型", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody PalletTypeBo bo) {
        palletTypeService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:palletType:edit")
    @Log(title = "托盘类型", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        palletTypeService.deleteById(id);
        return R.ok();
    }
}

