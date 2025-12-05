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
import com.ruoyi.wms.service.ValveService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.ValveBo;
import com.ruoyi.wms.domain.vo.ValveVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/valve")
public class ValveController extends BaseController {

    private final ValveService valveService;

    @SaCheckPermission("wms:valve:list")
    @GetMapping("/list")
    public TableDataInfo<ValveVo> list(ValveBo bo, PageQuery pageQuery) {
        return valveService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:valve:list")
    @GetMapping("/listNoPage")
    public R<List<ValveVo>> listNoPage(ValveBo bo) {
        return R.ok(valveService.queryList(bo));
    }

    @SaCheckPermission("wms:valve:list")
    @GetMapping("/status/{status}")
    public R<List<ValveVo>> getByStatus(@PathVariable Integer status) {
        return R.ok(valveService.queryByStatus(status));
    }

    @SaCheckPermission("wms:valve:list")
    @GetMapping("/code/{valveNo}")
    public R<ValveVo> getByValveNo(@PathVariable String valveNo) {
        return R.ok(valveService.queryByValveNo(valveNo));
    }

    @SaCheckPermission("wms:valve:export")
    @Log(title = "阀门", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(ValveBo bo, HttpServletResponse response) {
        List<ValveVo> list = valveService.queryList(bo);
        ExcelUtil.exportExcel(list, "阀门", ValveVo.class, response);
    }

    @SaCheckPermission("wms:valve:list")
    @GetMapping("/{id}")
    public R<ValveVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(valveService.queryById(id));
    }

    @SaCheckPermission("wms:valve:edit")
    @Log(title = "阀门", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody ValveBo bo) {
        valveService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:valve:edit")
    @Log(title = "阀门", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody ValveBo bo) {
        valveService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:valve:edit")
    @Log(title = "阀门", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        valveService.deleteById(id);
        return R.ok();
    }

    @SaCheckPermission("wms:valve:edit")
    @Log(title = "阀门", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/status")
    public R<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        valveService.updateStatus(id, status);
        return R.ok();
    }

    @SaCheckPermission("wms:valve:edit")
    @Log(title = "阀门", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/bindPallet")
    public R<Void> bindPallet(@PathVariable Long id, @RequestParam Long palletId, @RequestParam String palletCode) {
        valveService.bindPallet(id, palletId, palletCode);
        return R.ok();
    }

    @SaCheckPermission("wms:valve:edit")
    @Log(title = "阀门", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/bin")
    public R<Void> updateBin(@PathVariable Long id, @RequestParam Long binId, @RequestParam String binCode) {
        valveService.updateValveBin(id, binId, binCode);
        return R.ok();
    }
}

