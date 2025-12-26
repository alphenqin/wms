package com.ruoyi.system.controller.system;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.log.annotation.Log;
import com.ruoyi.common.log.enums.BusinessType;
import com.ruoyi.common.web.core.BaseController;
import com.ruoyi.system.domain.bo.SysConfigBo;
import com.ruoyi.system.service.SysConfigService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 参数配置 信息操作处理
 *
 * @author Lion Li
 */
@RequiredArgsConstructor
@RestController
@RequestMapping("/system/config")
public class SysConfigController extends BaseController {

    private final SysConfigService configService;

    /**
     * 根据参数键名查询参数值
     *
     * @param configKey 参数Key
     */
    @GetMapping(value = "/configKey/{configKey}")
    public R<Void> getConfigKey(@PathVariable String configKey) {
        return R.ok(configService.selectConfigByKey(configKey));
    }

    /**
     * 根据参数键名修改参数配置
     */
    @SaCheckPermission("system:config:edit")
    @Log(title = "参数管理", businessType = BusinessType.UPDATE)
    @PutMapping("/updateByKey")
    public R<Void> updateByKey(@RequestBody SysConfigBo config) {
        configService.updateConfig(config);
        return R.ok();
    }

}
