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
import com.ruoyi.wms.service.BinService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.BinBo;
import com.ruoyi.wms.domain.vo.BinVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/bin")
public class BinController extends BaseController {

    private final BinService binService;

    /**
     * 查询货位列表
     */
    @SaCheckPermission("wms:bin:list")
    @GetMapping("/list")
    public TableDataInfo<BinVo> list(BinBo bo, PageQuery pageQuery) {
        return binService.queryPageList(bo, pageQuery);
    }

    /**
     * 查询货位列表（不分页）
     */
    @SaCheckPermission("wms:bin:list")
    @GetMapping("/listNoPage")
    public R<List<BinVo>> listNoPage(BinBo bo) {
        return R.ok(binService.queryList(bo));
    }

    /**
     * 查询空闲货位列表
     */
    @SaCheckPermission("wms:bin:list")
    @GetMapping("/available")
    public R<List<BinVo>> getAvailableBins(@RequestParam(required = false) Long warehouseId,
                                           @RequestParam(required = false) Long areaId) {
        return R.ok(binService.queryAvailableBins(warehouseId, areaId));
    }

    /**
     * 根据货位编号查询
     */
    @SaCheckPermission("wms:bin:list")
    @GetMapping("/code/{binCode}")
    public R<BinVo> getByBinCode(@PathVariable String binCode) {
        return R.ok(binService.queryByBinCode(binCode));
    }

    /**
     * 导出货位列表
     */
    @SaCheckPermission("wms:bin:export")
    @Log(title = "货位", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(BinBo bo, HttpServletResponse response) {
        List<BinVo> list = binService.queryList(bo);
        ExcelUtil.exportExcel(list, "货位", BinVo.class, response);
    }

    /**
     * 获取货位详细信息
     */
    @SaCheckPermission("wms:bin:list")
    @GetMapping("/{id}")
    public R<BinVo> getInfo(@NotNull(message = "主键不能为空")
                           @PathVariable Long id) {
        return R.ok(binService.queryById(id));
    }

    /**
     * 新增货位
     */
    @SaCheckPermission("wms:bin:edit")
    @Log(title = "货位", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody BinBo bo) {
        binService.insertByBo(bo);
        return R.ok();
    }

    /**
     * 修改货位
     */
    @SaCheckPermission("wms:bin:edit")
    @Log(title = "货位", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody BinBo bo) {
        binService.updateByBo(bo);
        return R.ok();
    }

    /**
     * 删除货位
     */
    @SaCheckPermission("wms:bin:edit")
    @Log(title = "货位", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空")
                         @PathVariable Long id) {
        binService.deleteById(id);
        return R.ok();
    }

    /**
     * 更新货位状态
     */
    @SaCheckPermission("wms:bin:edit")
    @Log(title = "货位", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/status")
    public R<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        binService.updateStatus(id, status);
        return R.ok();
    }
}

