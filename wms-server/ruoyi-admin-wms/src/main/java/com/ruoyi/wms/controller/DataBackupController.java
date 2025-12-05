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
import com.ruoyi.wms.service.DataBackupService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.DataBackupBo;
import com.ruoyi.wms.domain.vo.DataBackupVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/dataBackup")
public class DataBackupController extends BaseController {

    private final DataBackupService dataBackupService;

    @SaCheckPermission("wms:backup:list")
    @GetMapping("/list")
    public TableDataInfo<DataBackupVo> list(DataBackupBo bo, PageQuery pageQuery) {
        return dataBackupService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:backup:list")
    @GetMapping("/listNoPage")
    public R<List<DataBackupVo>> listNoPage(DataBackupBo bo) {
        return R.ok(dataBackupService.queryList(bo));
    }

    @SaCheckPermission("wms:backup:export")
    @Log(title = "数据备份", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(DataBackupBo bo, HttpServletResponse response) {
        List<DataBackupVo> list = dataBackupService.queryList(bo);
        ExcelUtil.exportExcel(list, "数据备份", DataBackupVo.class, response);
    }

    @SaCheckPermission("wms:backup:list")
    @GetMapping("/{id}")
    public R<DataBackupVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(dataBackupService.queryById(id));
    }

    @SaCheckPermission("wms:backup:edit")
    @Log(title = "数据备份", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody DataBackupBo bo) {
        dataBackupService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:backup:edit")
    @Log(title = "数据备份", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody DataBackupBo bo) {
        dataBackupService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:backup:edit")
    @Log(title = "数据备份", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        dataBackupService.deleteById(id);
        return R.ok();
    }

    /**
     * 执行数据备份
     */
    @SaCheckPermission("wms:backup:backup")
    @Log(title = "数据备份", businessType = BusinessType.OTHER)
    @PostMapping("/execute")
    public R<String> executeBackup(@RequestParam Integer backupType,
                                    @RequestParam(required = false) String backupName) {
        String backupPath = dataBackupService.executeBackup(backupType, backupName);
        return R.ok(backupPath);
    }

    /**
     * 恢复数据备份
     */
    @SaCheckPermission("wms:backup:restore")
    @Log(title = "数据备份", businessType = BusinessType.OTHER)
    @PostMapping("/{id}/restore")
    public R<Void> restoreBackup(@PathVariable Long id) {
        dataBackupService.restoreBackup(id);
        return R.ok();
    }
}

