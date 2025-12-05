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
import com.ruoyi.wms.service.WarehouseKeeperService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.WarehouseKeeperBo;
import com.ruoyi.wms.domain.vo.WarehouseKeeperVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/warehouseKeeper")
public class WarehouseKeeperController extends BaseController {

    private final WarehouseKeeperService warehouseKeeperService;

    @SaCheckPermission("wms:warehouseKeeper:list")
    @GetMapping("/list")
    public TableDataInfo<WarehouseKeeperVo> list(WarehouseKeeperBo bo, PageQuery pageQuery) {
        return warehouseKeeperService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:warehouseKeeper:list")
    @GetMapping("/listNoPage")
    public R<List<WarehouseKeeperVo>> listNoPage(WarehouseKeeperBo bo) {
        return R.ok(warehouseKeeperService.queryList(bo));
    }

    @SaCheckPermission("wms:warehouseKeeper:export")
    @Log(title = "库管员", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(WarehouseKeeperBo bo, HttpServletResponse response) {
        List<WarehouseKeeperVo> list = warehouseKeeperService.queryList(bo);
        ExcelUtil.exportExcel(list, "库管员", WarehouseKeeperVo.class, response);
    }

    @SaCheckPermission("wms:warehouseKeeper:list")
    @GetMapping("/{id}")
    public R<WarehouseKeeperVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(warehouseKeeperService.queryById(id));
    }

    @SaCheckPermission("wms:warehouseKeeper:edit")
    @Log(title = "库管员", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody WarehouseKeeperBo bo) {
        warehouseKeeperService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:warehouseKeeper:edit")
    @Log(title = "库管员", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody WarehouseKeeperBo bo) {
        warehouseKeeperService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:warehouseKeeper:edit")
    @Log(title = "库管员", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        warehouseKeeperService.deleteById(id);
        return R.ok();
    }
}

