package com.ruoyi.system.runner;

import com.ruoyi.common.core.config.RuoYiConfig;
import com.ruoyi.system.service.SysConfigService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

/**
 * 初始化 system 模块对应业务数据
 *
 * @author Lion Li
 */
@Slf4j
@RequiredArgsConstructor
@Component
public class SystemApplicationRunner implements ApplicationRunner {

    private final RuoYiConfig ruoyiConfig;
    private final SysConfigService configService;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        if (ruoyiConfig.isCacheLazy()) {
            return;
        }
        configService.loadingConfigCache();
        log.debug("参数缓存加载完成（Redis 已移除）");
    }

}
