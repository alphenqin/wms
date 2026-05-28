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
import com.ruoyi.wms.domain.bo.OutsideStationBo;
import com.ruoyi.wms.domain.vo.OutsideStationVo;
import com.ruoyi.wms.service.OutsideStationService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/outsideStation")
public class OutsideStationController extends BaseController {

    private final OutsideStationService outsideStationService;

    @SaCheckPermission("wms:outsideStation:list")
    @GetMapping("/list")
    public TableDataInfo<OutsideStationVo> list(OutsideStationBo bo, PageQuery pageQuery) {
        return outsideStationService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:outsideStation:list")
    @GetMapping("/listNoPage")
    public R<List<OutsideStationVo>> listNoPage(OutsideStationBo bo) {
        return R.ok(outsideStationService.queryList(bo));
    }

    @SaCheckPermission("wms:outsideStation:export")
    @Log(title = "库外站点", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(OutsideStationBo bo, HttpServletResponse response) {
        List<OutsideStationVo> list = outsideStationService.queryList(bo);
        ExcelUtil.exportExcel(list, "库外站点", OutsideStationVo.class, response);
    }

    @SaCheckPermission("wms:outsideStation:list")
    @GetMapping("/{id}")
    public R<OutsideStationVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(outsideStationService.queryById(id));
    }

    @SaCheckPermission("wms:outsideStation:add")
    @Log(title = "库外站点", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody OutsideStationBo bo) {
        outsideStationService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:outsideStation:edit")
    @Log(title = "库外站点", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody OutsideStationBo bo) {
        outsideStationService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:outsideStation:remove")
    @Log(title = "库外站点", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        outsideStationService.deleteById(id);
        return R.ok();
    }

    @SaCheckPermission("wms:outsideStation:remove")
    @Log(title = "库外站点", businessType = BusinessType.DELETE)
    @DeleteMapping("/batch/{ids}")
    public R<Void> removeBatch(@NotNull(message = "主键不能为空") @PathVariable Long[] ids) {
        outsideStationService.deleteByIds(Arrays.asList(ids));
        return R.ok();
    }
}
