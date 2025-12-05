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
import com.ruoyi.wms.service.AgvTaskService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.wms.domain.bo.AgvTaskBo;
import com.ruoyi.wms.domain.vo.AgvTaskVo;

import java.util.List;

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/wms/agvTask")
public class AgvTaskController extends BaseController {

    private final AgvTaskService agvTaskService;

    @SaCheckPermission("wms:agvTask:list")
    @GetMapping("/list")
    public TableDataInfo<AgvTaskVo> list(AgvTaskBo bo, PageQuery pageQuery) {
        return agvTaskService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:agvTask:list")
    @GetMapping("/listNoPage")
    public R<List<AgvTaskVo>> listNoPage(AgvTaskBo bo) {
        return R.ok(agvTaskService.queryList(bo));
    }

    @SaCheckPermission("wms:agvTask:list")
    @GetMapping("/status/{status}")
    public R<List<AgvTaskVo>> getByStatus(@PathVariable Integer status) {
        return R.ok(agvTaskService.queryByStatus(status));
    }

    @SaCheckPermission("wms:agvTask:list")
    @GetMapping("/executing")
    public R<List<AgvTaskVo>> getExecutingTasks() {
        return R.ok(agvTaskService.queryExecutingTasks());
    }

    @SaCheckPermission("wms:agvTask:list")
    @GetMapping("/taskNo/{taskNo}")
    public R<AgvTaskVo> getByTaskNo(@PathVariable String taskNo) {
        return R.ok(agvTaskService.queryByTaskNo(taskNo));
    }

    @SaCheckPermission("wms:agvTask:export")
    @Log(title = "AGV任务", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(AgvTaskBo bo, HttpServletResponse response) {
        List<AgvTaskVo> list = agvTaskService.queryList(bo);
        ExcelUtil.exportExcel(list, "AGV任务", AgvTaskVo.class, response);
    }

    @SaCheckPermission("wms:agvTask:list")
    @GetMapping("/{id}")
    public R<AgvTaskVo> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return R.ok(agvTaskService.queryById(id));
    }

    @SaCheckPermission("wms:agvTask:edit")
    @Log(title = "AGV任务", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public R<Void> add(@Validated(AddGroup.class) @RequestBody AgvTaskBo bo) {
        agvTaskService.insertByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:agvTask:edit")
    @Log(title = "AGV任务", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody AgvTaskBo bo) {
        agvTaskService.updateByBo(bo);
        return R.ok();
    }

    @SaCheckPermission("wms:agvTask:edit")
    @Log(title = "AGV任务", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        agvTaskService.deleteById(id);
        return R.ok();
    }

    @SaCheckPermission("wms:agvTask:edit")
    @Log(title = "AGV任务", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/cancel")
    public R<Void> cancelTask(@PathVariable Long id) {
        agvTaskService.cancelTask(id);
        return R.ok();
    }

    /**
     * AGV回调接口 - 更新任务状态（不需要权限验证，由AGV系统调用）
     */
    @PostMapping("/callback/status")
    public R<Void> updateStatusCallback(@RequestParam String agvTaskId,
                                         @RequestParam Integer status,
                                         @RequestParam(required = false) String agvDeviceNo,
                                         @RequestParam(required = false) String agvResponse,
                                         @RequestParam(required = false) String errorMsg) {
        agvTaskService.updateTaskStatus(agvTaskId, status, agvDeviceNo, agvResponse, errorMsg);
        return R.ok();
    }
}

