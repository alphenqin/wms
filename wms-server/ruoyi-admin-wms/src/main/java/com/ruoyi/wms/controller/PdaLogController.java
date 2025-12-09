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
import com.ruoyi.wms.service.PdaLogService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.PdaLogBo;
import com.ruoyi.wms.domain.vo.PdaLogVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/pda/log")
public class PdaLogController extends BaseController {

    private final PdaLogService pdaLogService;

    @SaCheckPermission("wms:pdaLog:list")
    @GetMapping("/list")
    public TableDataInfo<PdaLogVo> list(PdaLogBo bo, PageQuery pageQuery) {
        return pdaLogService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:pdaLog:list")
    @GetMapping("/listNoPage")
    public R<List<PdaLogVo>> listNoPage(PdaLogBo bo) {
        return R.ok(pdaLogService.queryList(bo));
    }

    @SaCheckPermission("wms:pdaLog:list")
    @GetMapping("/error")
    public R<List<PdaLogVo>> getErrorLogs(@RequestParam(required = false) String pdaDeviceNo) {
        return R.ok(pdaLogService.queryErrorLogs(pdaDeviceNo));
    }

    @SaCheckPermission("wms:pdaLog:list")
    @GetMapping("/networkFailure")
    public R<List<PdaLogVo>> getNetworkFailures(@RequestParam(required = false) String pdaDeviceNo) {
        return R.ok(pdaLogService.queryNetworkFailures(pdaDeviceNo));
    }

    @SaCheckPermission("wms:pdaLog:export")
    @Log(title = "PDA日志", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(PdaLogBo bo, HttpServletResponse response) {
        List<PdaLogVo> list = pdaLogService.queryList(bo);
        ExcelUtil.exportExcel(list, "PDA日志", PdaLogVo.class, response);
    }

    @SaCheckPermission("wms:pdaLog:list")
    @GetMapping("/{id}")
    public R<PdaLogVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(pdaLogService.queryById(id));
    }

    @SaCheckPermission("wms:pdaLog:edit")
    @Log(title = "PDA日志", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody PdaLogBo bo) {
        pdaLogService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:pdaLog:edit")
    @Log(title = "PDA日志", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody PdaLogBo bo) {
        pdaLogService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:pdaLog:edit")
    @Log(title = "PDA日志", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        pdaLogService.deleteById(id);
        return R.ok();
    }
}

