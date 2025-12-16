package com.ruoyi.wms.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.log.annotation.Log;
import com.ruoyi.common.log.enums.BusinessType;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.common.web.core.BaseController;
import com.ruoyi.wms.domain.bo.AgvOpenTaskBo;
import com.ruoyi.wms.domain.vo.AgvOpenTaskVo;
import com.ruoyi.wms.service.AgvOpenTaskService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * AGV开放接口入口
 * 对接 192.168.1.20:81/pt/* API
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/wms/agv/open")
public class AgvOpenController extends BaseController {

    private final AgvOpenTaskService agvOpenTaskService;

    @SaCheckPermission("wms:agvOpen:task:list")
    @GetMapping("/task/list")
    public TableDataInfo<AgvOpenTaskVo> list(AgvOpenTaskBo bo, PageQuery pageQuery) {
        return agvOpenTaskService.queryPageList(bo, pageQuery);
    }

    @SaCheckPermission("wms:agvOpen:task:list")
    @GetMapping("/task/{id}")
    public R<AgvOpenTaskVo> get(@PathVariable Long id) {
        return R.ok(agvOpenTaskService.queryById(id));
    }

    @SaCheckPermission("wms:agvOpen:task:send")
    @Log(title = "AGV任务下发", businessType = BusinessType.OTHER)
    @PostMapping("/task/send")
    public R<AgvOpenTaskVo> sendTask(@Validated(AddGroup.class) @RequestBody AgvOpenTaskBo bo) {
        return R.ok(agvOpenTaskService.sendTask(bo));
    }

    @SaCheckPermission("wms:agvOpen:task:result")
    @Log(title = "AGV任务结果查询", businessType = BusinessType.OTHER)
    @PostMapping("/task/result")
    public R<AgvOpenTaskVo> queryResult(@Valid @RequestBody ResultQuery request) {
        return R.ok(agvOpenTaskService.refreshTaskResult(request.getOutId()));
    }

    @SaCheckPermission("wms:agvOpen:bin:assign")
    @Log(title = "AGV库位分配", businessType = BusinessType.OTHER)
    @PostMapping("/bin/assign")
    public R<Map<String, Object>> findBin(@RequestBody Map<String, Object> body) {
        return R.ok(agvOpenTaskService.findBin(body));
    }

    @SaCheckPermission("wms:agvOpen:bin:info")
    @PostMapping("/bin/info")
    public R<Map<String, Object>> binInfo(@RequestBody(required = false) Map<String, Object> body) {
        String binCode = body != null ? (String) body.get("binCode") : null;
        return R.ok(agvOpenTaskService.binInfo(binCode));
    }

    @SaCheckPermission("wms:agvOpen:bin:update")
    @Log(title = "AGV库位状态更新", businessType = BusinessType.OTHER)
    @PostMapping("/bin/status")
    public R<Map<String, Object>> updateBinStatus(@RequestBody BinStatusReq req) {
        return R.ok(agvOpenTaskService.updateBinStatus(req.getBinCode()));
    }

    @SaCheckPermission("wms:agvOpen:agvInfo")
    @PostMapping("/agv/info")
    public R<Map<String, Object>> agvInfo() {
        return R.ok(agvOpenTaskService.agvInfo());
    }

    @Data
    public static class ResultQuery {
        @NotBlank(message = "外部业务ID不能为空")
        private String outId;
    }

    @Data
    public static class BinStatusReq {
        @NotBlank(message = "库位编号不能为空")
        private String binCode;
    }
}

