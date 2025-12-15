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
import org.springframework.web.client.RestTemplate;

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
    private final RestTemplate restTemplate;

    @Value("${agv.open.base-url:http://192.168.1.20:81}")
    private String agvBaseUrl;

    public AgvOpenTaskService(AgvOpenTaskMapper mapper, RestTemplateBuilder builder) {
        this.agvOpenTaskMapper = mapper;
        this.restTemplate = builder
            .setConnectTimeout(Duration.ofSeconds(5))
            .setReadTimeout(Duration.ofSeconds(15))
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
    public AgvOpenTaskVo sendTask(AgvOpenTaskBo bo) {
        validateSendTask(bo);
        String outId = StrUtil.blankToDefault(bo.getOutId(), generateOutId());
        bo.setOutId(outId);

        Map<String, Object> payload = buildTaskPayload(bo);
        Map<String, Object> agvResp = postForMap("/pt/taskSent", payload);
        ensureSuccess(agvResp, "下发任务失败");

        AgvOpenTask entity = MapstructUtils.convert(bo, AgvOpenTask.class);
        entity.setPointsJson(JsonUtils.toJsonString(bo.getSafePoints()));
        entity.setRequestPayload(JsonUtils.toJsonString(payload));
        entity.setResponseCode(MapUtil.getStr(agvResp, "code"));
        entity.setResponseMessage(MapUtil.getStr(agvResp, "message"));
        entity.setStatus("01"); // 默认等待执行
        saveOrUpdateByOutId(entity);
        return MapstructUtils.convert(entity, AgvOpenTaskVo.class);
    }

    @Transactional(rollbackFor = Exception.class)
    public AgvOpenTaskVo refreshTaskResult(String outId) {
        if (StrUtil.isBlank(outId)) {
            throw new ServiceException("外部业务ID不能为空");
        }
        Map<String, Object> req = new HashMap<>();
        req.put("outID", outId);
        Map<String, Object> agvResp = postForMap("/pt/taskResult", req);
        ensureSuccess(agvResp, "查询任务结果失败");

        AgvOpenTask entity = getByOutId(outId).orElseGet(AgvOpenTask::new);
        entity.setOutId(outId);
        entity.setStatus(MapUtil.getStr(agvResp, "status"));
        entity.setAgvCode(MapUtil.getStr(agvResp, "agvCode"));
        entity.setLastResult(JsonUtils.toJsonString(agvResp));
        entity.setResponseCode(MapUtil.getStr(agvResp, "code"));
        entity.setResponseMessage(MapUtil.getStr(agvResp, "message"));
        saveOrUpdateByOutId(entity);
        return MapstructUtils.convert(entity, AgvOpenTaskVo.class);
    }

    public Map<String, Object> findBin(Map<String, Object> body) {
        if (body == null || StrUtil.isBlank(MapUtil.getStr(body, "findType"))) {
            throw new ServiceException("findType不能为空");
        }
        Map<String, Object> agvResp = postForMap("/pt/findBin", body);
        ensureSuccess(agvResp, "分配库位失败");
        return agvResp;
    }

    public Map<String, Object> binInfo(String binCode) {
        Map<String, Object> body = new HashMap<>();
        if (StrUtil.isNotBlank(binCode)) {
            body.put("binCode", binCode);
        }
        Map<String, Object> agvResp = postForMap("/pt/binInfo", body);
        ensureSuccess(agvResp, "查询库位信息失败");
        return agvResp;
    }

    public Map<String, Object> updateBinStatus(String binCode) {
        if (StrUtil.isBlank(binCode)) {
            throw new ServiceException("库位编号不能为空");
        }
        Map<String, Object> body = new HashMap<>();
        body.put("binCode", binCode);
        Map<String, Object> agvResp = postForMap("/pt/updateBinStatus", body);
        ensureSuccess(agvResp, "更新库位状态失败");
        return agvResp;
    }

    public Map<String, Object> agvInfo() {
        Map<String, Object> agvResp = postForMap("/pt/agvInfo", Collections.emptyMap());
        ensureSuccess(agvResp, "查询AGV信息失败");
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
        payload.put("points", bo.getSafePoints());
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
                throw new ServiceException("AGV接口调用失败: " + url);
            }
            return response.getBody();
        } catch (Exception e) {
            log.error("调用AGV接口失败, url={}, payload={}", url, JsonUtils.toJsonString(payload), e);
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

