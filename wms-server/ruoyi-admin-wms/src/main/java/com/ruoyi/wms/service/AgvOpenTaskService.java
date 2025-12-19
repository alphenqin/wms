package com.ruoyi.wms.service;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.map.MapUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.json.utils.JsonUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.domain.bo.AgvOpenTaskBo;
import com.ruoyi.wms.domain.entity.AgvOpenTask;
import com.ruoyi.wms.domain.vo.AgvOpenTaskVo;
import com.ruoyi.wms.mapper.AgvOpenTaskMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import jakarta.annotation.PostConstruct;
import java.time.Duration;
import java.util.*;

/**
 * AGV开放接口相关服务
 * 对接外部调度系统的 /pt/* 接口
 */
@Slf4j
@Service
public class AgvOpenTaskService extends ServiceImpl<AgvOpenTaskMapper, AgvOpenTask> {

    private final AgvOpenTaskMapper agvOpenTaskMapper;
    private final RestTemplateBuilder restTemplateBuilder;
    private RestTemplate restTemplate;

    @Value("${agv.open.base-url:http://192.168.1.20:81}")
    private String agvBaseUrl;

    @Value("${agv.open.connect-timeout:10}")
    private int connectTimeout;

    @Value("${agv.open.read-timeout:30}")
    private int readTimeout;

    public AgvOpenTaskService(AgvOpenTaskMapper mapper, RestTemplateBuilder builder) {
        this.agvOpenTaskMapper = mapper;
        this.restTemplateBuilder = builder;
    }

    @PostConstruct
    private void initRestTemplate() {
        this.restTemplate = restTemplateBuilder
            .setConnectTimeout(Duration.ofSeconds(connectTimeout))
            .setReadTimeout(Duration.ofSeconds(readTimeout))
            .build();
    }

    public TableDataInfo<AgvOpenTaskVo> queryPageList(AgvOpenTaskBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<AgvOpenTask> lqw = buildQueryWrapper(bo);
        Page<AgvOpenTaskVo> result = agvOpenTaskMapper.selectVoPage(pageQuery.build(), lqw);
        return TableDataInfo.build(result);
    }

    public List<AgvOpenTaskVo> queryList(AgvOpenTaskBo bo) {
        LambdaQueryWrapper<AgvOpenTask> lqw = buildQueryWrapper(bo);
        return agvOpenTaskMapper.selectVoList(lqw);
    }

    public AgvOpenTaskVo queryById(Long id) {
        return agvOpenTaskMapper.selectVoById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> sendTask(AgvOpenTaskBo bo) {
        validateSendTask(bo);
        String outId = StrUtil.blankToDefault(bo.getOutId(), generateOutId());
        bo.setOutId(outId);

        Map<String, Object> payload = buildTaskPayload(bo);
        Map<String, Object> agvResp = postForMap("/pt/taskSent", payload);
        String code = MapUtil.getStr(agvResp, "code");
        if ("20000".equals(code)) {
            AgvOpenTask entity = MapstructUtils.convert(bo, AgvOpenTask.class);
            entity.setPointsJson(JsonUtils.toJsonString(bo.getSafePoints()));
            entity.setRequestPayload(JsonUtils.toJsonString(payload));
            entity.setResponseCode(code);
            entity.setResponseMessage(MapUtil.getStr(agvResp, "message"));
            entity.setStatus("01"); // 默认等待执行
            saveOrUpdateByOutId(entity);
        }
        Map<String, Object> result = new HashMap<>();
        result.put("code", code);
        result.put("message", MapUtil.getStr(agvResp, "message"));
        return result;
    }

    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> refreshTaskResult(String outId) {
        if (StrUtil.isBlank(outId)) {
            throw new ServiceException("外部业务ID不能为空");
        }
        Map<String, Object> req = new HashMap<>();
        req.put("outID", outId);
        Map<String, Object> agvResp = postForMap("/pt/taskResult", req);
        String code = MapUtil.getStr(agvResp, "code");
        if ("20000".equals(code)) {
            AgvOpenTask entity = getByOutId(outId).orElseGet(AgvOpenTask::new);
            entity.setOutId(outId);
            entity.setStatus(MapUtil.getStr(agvResp, "status"));
            entity.setAgvCode(MapUtil.getStr(agvResp, "agvCode"));
            entity.setLastResult(JsonUtils.toJsonString(agvResp));
            entity.setResponseCode(code);
            entity.setResponseMessage(MapUtil.getStr(agvResp, "message"));
            saveOrUpdateByOutId(entity);
        }
        Map<String, Object> result = new HashMap<>();
        result.put("code", code);
        result.put("status", MapUtil.getStr(agvResp, "status"));
        result.put("points", agvResp.get("points"));
        result.put("agvCode", MapUtil.getStr(agvResp, "agvCode"));
        result.put("message", MapUtil.getStr(agvResp, "message"));
        return result;
    }

    public Map<String, Object> findBin(Map<String, Object> body) {
        if (body == null || StrUtil.isBlank(MapUtil.getStr(body, "findType"))) {
            throw new ServiceException("findType不能为空");
        }
        Map<String, Object> agvResp = postForMap("/pt/findBin", body);
        return agvResp;
    }

    public Map<String, Object> binInfo(String binCode) {
        Map<String, Object> body = new HashMap<>();
        if (StrUtil.isNotBlank(binCode)) {
            body.put("binCode", binCode);
        }
        Map<String, Object> agvResp = postForMap("/pt/binInfo", body);
        return agvResp;
    }

    public Map<String, Object> updateBinStatus(String binCode) {
        if (StrUtil.isBlank(binCode)) {
            throw new ServiceException("库位编号不能为空");
        }
        Map<String, Object> body = new HashMap<>();
        body.put("binCode", binCode);
        Map<String, Object> agvResp = postForMap("/pt/updateBinStatus", body);
        return agvResp;
    }

    public Map<String, Object> agvInfo() {
        Map<String, Object> agvResp = postForMap("/pt/agvInfo", Collections.emptyMap());
        return agvResp;
    }

    private LambdaQueryWrapper<AgvOpenTask> buildQueryWrapper(AgvOpenTaskBo bo) {
        LambdaQueryWrapper<AgvOpenTask> lqw = Wrappers.lambdaQuery();
        lqw.like(StrUtil.isNotBlank(bo.getOutId()), AgvOpenTask::getOutId, bo.getOutId());
        lqw.eq(StrUtil.isNotBlank(bo.getTaskType()), AgvOpenTask::getTaskType, bo.getTaskType());
        lqw.eq(StrUtil.isNotBlank(bo.getStatus()), AgvOpenTask::getStatus, bo.getStatus());
        lqw.eq(StrUtil.isNotBlank(bo.getAgvCode()), AgvOpenTask::getAgvCode, bo.getAgvCode());
        lqw.orderByDesc(AgvOpenTask::getCreateTime);
        return lqw;
    }

    private void validateSendTask(AgvOpenTaskBo bo) {
        if (StrUtil.isBlank(bo.getTaskType())) {
            throw new ServiceException("任务类型不能为空");
        }
        if (!StrUtil.equalsAny(bo.getTaskType(), "01", "05", "10", "12", "13", "18")) {
            throw new ServiceException("任务类型不合法");
        }
        // 需要作业点的任务
        if ("01".equals(bo.getTaskType()) && CollUtil.isEmpty(bo.getSafePoints())) {
            throw new ServiceException("取放货任务必须包含作业点信息");
        }
        // 需要 agvRange 的任务
        if (StrUtil.equalsAny(bo.getTaskType(), "05", "10", "12", "18") && StrUtil.isBlank(bo.getAgvRange())) {
            throw new ServiceException("当前任务类型必须指定AGV范围");
        }
        if ("13".equals(bo.getTaskType()) && StrUtil.isBlank(bo.getClearOutId())) {
            throw new ServiceException("清空任务时 clearOutID 不能为空");
        }
    }

    private Map<String, Object> buildTaskPayload(AgvOpenTaskBo bo) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("taskCode", bo.getTaskCode());
        payload.put("type", bo.getTaskType());
        payload.put("IsOrder", StrUtil.blankToDefault(bo.getIsOrder(), "false"));
        payload.put("agvRange", bo.getAgvRange());
        if ("01".equals(bo.getTaskType())) {
            payload.put("points", bo.getSafePoints());
        }
        payload.put("level", bo.getLevel());
        payload.put("clearOutID", bo.getClearOutId());
        payload.put("outID", bo.getOutId());
        return payload;
    }

    private Map<String, Object> postForMap(String path, Object payload) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Object> entity = new HttpEntity<>(payload, headers);
        String url = formatUrl(path);
        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
            if (!response.getStatusCode().is2xxSuccessful() || response.getBody() == null) {
                throw new ServiceException("AGV接口调用失败: " + url + ", 状态码: " + response.getStatusCode());
            }
            return response.getBody();
        } catch (RestClientException e) {
            String errorMsg = e.getMessage();
            // 针对连接超时和读取超时的特殊处理
            if (errorMsg != null) {
                if (errorMsg.contains("timeout") || errorMsg.contains("timed out")) {
                    log.error("AGV接口调用超时, url={}, 连接超时={}s, 读取超时={}s, payload={}", 
                        url, connectTimeout, readTimeout, JsonUtils.toJsonString(payload), e);
                    throw new ServiceException(String.format("AGV接口调用超时: %s (连接超时:%ds, 读取超时:%ds)", 
                        url, connectTimeout, readTimeout));
                } else if (errorMsg.contains("unexpected end of stream") || errorMsg.contains("Connection reset")) {
                    log.error("AGV接口连接异常, url={}, 可能是服务端提前关闭连接或网络中断, payload={}", 
                        url, JsonUtils.toJsonString(payload), e);
                    throw new ServiceException("AGV接口连接异常: " + url + " (服务端可能提前关闭连接或网络中断，请检查AGV调度系统状态)");
                } else if (errorMsg.contains("Connection refused") || errorMsg.contains("No route to host")) {
                    log.error("AGV接口无法连接, url={}, 请检查网络连接和AGV调度系统是否启动, payload={}", 
                        url, JsonUtils.toJsonString(payload), e);
                    throw new ServiceException("AGV接口无法连接: " + url + " (请检查网络连接和AGV调度系统是否启动)");
                }
            }
            log.error("调用AGV接口失败, url={}, payload={}", url, JsonUtils.toJsonString(payload), e);
            throw new ServiceException("AGV接口调用异常: " + errorMsg);
        } catch (Exception e) {
            log.error("调用AGV接口发生未知异常, url={}, payload={}", url, JsonUtils.toJsonString(payload), e);
            throw new ServiceException("AGV接口调用异常: " + e.getMessage());
        }
    }

    private void ensureSuccess(Map<String, Object> resp, String defaultMsg) {
        String code = MapUtil.getStr(resp, "code");
        if (!"20000".equals(code)) {
            String message = MapUtil.getStr(resp, "message");
            throw new ServiceException(StrUtil.emptyToDefault(message, defaultMsg));
        }
    }

    private String formatUrl(String path) {
        String base = StrUtil.removeSuffix(agvBaseUrl, "/");
        String suffix = path.startsWith("/") ? path : ("/" + path);
        return base + suffix;
    }

    private String generateOutId() {
        return "AGV" + System.currentTimeMillis();
    }

    private Optional<AgvOpenTask> getByOutId(String outId) {
        LambdaQueryWrapper<AgvOpenTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvOpenTask::getOutId, outId);
        return Optional.ofNullable(agvOpenTaskMapper.selectOne(wrapper));
    }

    private void saveOrUpdateByOutId(AgvOpenTask entity) {
        getByOutId(entity.getOutId()).ifPresent(exist -> entity.setId(exist.getId()));
        this.saveOrUpdate(entity);
    }
}

