package com.ruoyi.common.oss.factory;

import com.ruoyi.common.core.utils.StringUtils;
import com.ruoyi.common.oss.core.OssClient;
import com.ruoyi.common.oss.exception.OssException;
import com.ruoyi.common.oss.properties.OssProperties;
import com.ruoyi.common.oss.provider.OssConfigProvider;
import com.ruoyi.common.core.utils.SpringUtils;
import lombok.extern.slf4j.Slf4j;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 文件上传Factory
 *
 * @author Lion Li
 */
@Slf4j
public class OssFactory {

    private static final Map<String, OssClient> CLIENT_CACHE = new ConcurrentHashMap<>();

    /**
     * 获取默认实例
     */
    public static OssClient instance() {
        OssConfigProvider provider = SpringUtils.getBean(OssConfigProvider.class);
        String configKey = provider.getDefaultConfigKey();
        if (StringUtils.isEmpty(configKey)) {
            throw new OssException("文件存储服务类型无法找到!");
        }
        return instance(configKey);
    }

    /**
     * 根据类型获取实例
     */
    public static synchronized OssClient instance(String configKey) {
        OssConfigProvider provider = SpringUtils.getBean(OssConfigProvider.class);
        OssProperties properties = provider.getOssProperties(configKey);
        if (properties == null) {
            throw new OssException("系统异常, '" + configKey + "'配置信息不存在!");
        }
        OssClient client = CLIENT_CACHE.get(configKey);
        if (client == null) {
            CLIENT_CACHE.put(configKey, new OssClient(configKey, properties));
            log.info("创建OSS实例 key => {}", configKey);
            return CLIENT_CACHE.get(configKey);
        }
        // 配置不相同则重新构建
        if (!client.checkPropertiesSame(properties)) {
            CLIENT_CACHE.put(configKey, new OssClient(configKey, properties));
            log.info("重载OSS实例 key => {}", configKey);
            return CLIENT_CACHE.get(configKey);
        }
        return client;
    }

}
