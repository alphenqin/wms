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
import com.ruoyi.wms.service.MaterialTypeService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.MaterialTypeBo;
import com.ruoyi.wms.domain.vo.MaterialTypeVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/materialType")
public class MaterialTypeController extends BaseController {

    private final MaterialTypeService materialTypeService;

    @SaCheckPermission("wms:materialType:list")
    @GetMapping("/list")
    public TableDataInfo<MaterialTypeVo> list(MaterialTypeBo bo, PageQuery pageQuery) {
        return materialTypeService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:materialType:list")
    @GetMapping("/listNoPage")
    public R<List<MaterialTypeVo>> listNoPage(MaterialTypeBo bo) {
        return R.ok(materialTypeService.queryList(bo));
    }

    @SaCheckPermission("wms:materialType:export")
    @Log(title = "物料类型", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(MaterialTypeBo bo, HttpServletResponse response) {
        List<MaterialTypeVo> list = materialTypeService.queryList(bo);
        ExcelUtil.exportExcel(list, "物料类型", MaterialTypeVo.class, response);
    }

    @SaCheckPermission("wms:materialType:list")
    @GetMapping("/{id}")
    public R<MaterialTypeVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(materialTypeService.queryById(id));
    }

    @SaCheckPermission("wms:materialType:edit")
    @Log(title = "物料类型", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody MaterialTypeBo bo) {
        materialTypeService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:materialType:edit")
    @Log(title = "物料类型", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody MaterialTypeBo bo) {
        materialTypeService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:materialType:edit")
    @Log(title = "物料类型", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        materialTypeService.deleteById(id);
        return R.ok();
    }
}

