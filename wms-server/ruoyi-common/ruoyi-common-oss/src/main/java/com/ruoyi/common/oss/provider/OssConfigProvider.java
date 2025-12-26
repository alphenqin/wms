package com.ruoyi.common.oss.provider;

import com.ruoyi.common.oss.properties.OssProperties;

/**
 * OSS 配置提供者
 */
public interface OssConfigProvider {

    /**
     * 获取默认配置 key
     */
    String getDefaultConfigKey();

    /**
     * 根据配置 key 获取 OSS 配置
     */
    OssProperties getOssProperties(String configKey);
}
