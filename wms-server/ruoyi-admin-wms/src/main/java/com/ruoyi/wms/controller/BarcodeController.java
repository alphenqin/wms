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
import com.ruoyi.wms.service.BarcodeService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.BarcodeBo;
import com.ruoyi.wms.domain.vo.BarcodeVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/barcode")
public class BarcodeController extends BaseController {

    private final BarcodeService barcodeService;

    @SaCheckPermission("wms:barcode:list")
    @GetMapping("/list")
    public TableDataInfo<BarcodeVo> list(BarcodeBo bo, PageQuery pageQuery) {
        return barcodeService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:barcode:list")
    @GetMapping("/listNoPage")
    public R<List<BarcodeVo>> listNoPage(BarcodeBo bo) {
        return R.ok(barcodeService.queryList(bo));
    }

    @SaCheckPermission("wms:barcode:list")
    @GetMapping("/code/{barcode}")
    public R<BarcodeVo> getByBarcode(@PathVariable String barcode) {
        return R.ok(barcodeService.queryByBarcode(barcode));
    }

    @SaCheckPermission("wms:barcode:export")
    @Log(title = "条码", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(BarcodeBo bo, HttpServletResponse response) {
        List<BarcodeVo> list = barcodeService.queryList(bo);
        ExcelUtil.exportExcel(list, "条码", BarcodeVo.class, response);
    }

    @SaCheckPermission("wms:barcode:list")
    @GetMapping("/{id}")
    public R<BarcodeVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(barcodeService.queryById(id));
    }

    @SaCheckPermission("wms:barcode:edit")
    @Log(title = "条码", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody BarcodeBo bo) {
        barcodeService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:barcode:edit")
    @Log(title = "条码", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody BarcodeBo bo) {
        barcodeService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:barcode:edit")
    @Log(title = "条码", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        barcodeService.deleteById(id);
        return R.ok();
    }
}

