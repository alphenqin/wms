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
import com.ruoyi.wms.service.PdaOperationService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.PdaOperationBo;
import com.ruoyi.wms.domain.vo.PdaOperationVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/pda/operation")
public class PdaOperationController extends BaseController {

    private final PdaOperationService pdaOperationService;

    @SaCheckPermission("wms:pda:operation:list")
    @GetMapping("/list")
    public TableDataInfo<PdaOperationVo> list(PdaOperationBo bo, PageQuery pageQuery) {
        return pdaOperationService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:pda:operation:list")
    @GetMapping("/listNoPage")
    public R<List<PdaOperationVo>> listNoPage(PdaOperationBo bo) {
        return R.ok(pdaOperationService.queryList(bo));
    }

    @SaCheckPermission("wms:pda:operation:export")
    @Log(title = "PDA操作", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(PdaOperationBo bo, HttpServletResponse response) {
        List<PdaOperationVo> list = pdaOperationService.queryList(bo);
        ExcelUtil.exportExcel(list, "PDA操作", PdaOperationVo.class, response);
    }

    @SaCheckPermission("wms:pda:operation:list")
    @GetMapping("/{id}")
    public R<PdaOperationVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(pdaOperationService.queryById(id));
    }

    @SaCheckPermission("wms:pda:operation:edit")
    @Log(title = "PDA操作", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody PdaOperationBo bo) {
        pdaOperationService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:pda:operation:edit")
    @Log(title = "PDA操作", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody PdaOperationBo bo) {
        pdaOperationService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:pda:operation:edit")
    @Log(title = "PDA操作", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        pdaOperationService.deleteById(id);
        return R.ok();
    }
}

