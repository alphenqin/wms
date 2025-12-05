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
import com.ruoyi.wms.service.PalletService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.PalletBo;
import com.ruoyi.wms.domain.vo.PalletVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/pallet")
public class PalletController extends BaseController {

    private final PalletService palletService;

    @SaCheckPermission("wms:pallet:list")
    @GetMapping("/list")
    public TableDataInfo<PalletVo> list(PalletBo bo, PageQuery pageQuery) {
        return palletService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:pallet:list")
    @GetMapping("/listNoPage")
    public R<List<PalletVo>> listNoPage(PalletBo bo) {
        return R.ok(palletService.queryList(bo));
    }

    @SaCheckPermission("wms:pallet:list")
    @GetMapping("/empty")
    public R<List<PalletVo>> getEmptyPallets(@RequestParam(required = false) Long warehouseId) {
        return R.ok(palletService.queryEmptyPallets(warehouseId));
    }

    @SaCheckPermission("wms:pallet:list")
    @GetMapping("/code/{palletCode}")
    public R<PalletVo> getByPalletCode(@PathVariable String palletCode) {
        return R.ok(palletService.queryByPalletCode(palletCode));
    }

    @SaCheckPermission("wms:pallet:export")
    @Log(title = "托盘", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(PalletBo bo, HttpServletResponse response) {
        List<PalletVo> list = palletService.queryList(bo);
        ExcelUtil.exportExcel(list, "托盘", PalletVo.class, response);
    }

    @SaCheckPermission("wms:pallet:list")
    @GetMapping("/{id}")
    public R<PalletVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(palletService.queryById(id));
    }

    @SaCheckPermission("wms:pallet:edit")
    @Log(title = "托盘", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody PalletBo bo) {
        palletService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:pallet:edit")
    @Log(title = "托盘", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody PalletBo bo) {
        palletService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:pallet:edit")
    @Log(title = "托盘", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        palletService.deleteById(id);
        return R.ok();
    }

    @SaCheckPermission("wms:pallet:edit")
    @Log(title = "托盘", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/bin")
    public R<Void> updateBin(@PathVariable Long id, @RequestParam Long binId, @RequestParam String binCode) {
        palletService.updatePalletBin(id, binId, binCode);
        return R.ok();
    }

    @SaCheckPermission("wms:pallet:edit")
    @Log(title = "托盘", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/bind")
    public R<Void> bindMaterial(@PathVariable Long id) {
        palletService.bindMaterial(id);
        return R.ok();
    }

    @SaCheckPermission("wms:pallet:edit")
    @Log(title = "托盘", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/unbind")
    public R<Void> unbindMaterial(@PathVariable Long id) {
        palletService.unbindMaterial(id);
        return R.ok();
    }
}

