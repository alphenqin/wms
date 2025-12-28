package com.ruoyi.wms.controller;

import cn.dev33.satoken.annotation.SaIgnore;
import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.map.MapUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.common.core.constant.HttpStatus;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.common.core.exception.user.UserException;
import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.satoken.utils.LoginHelper;
import com.ruoyi.common.core.domain.bo.LoginUser;
import com.ruoyi.system.service.SysLoginService;
import com.ruoyi.system.service.SysUserService;
import com.ruoyi.system.domain.vo.SysUserVo;
import com.ruoyi.wms.domain.bo.AgvOpenTaskBo;
import com.ruoyi.wms.domain.bo.AgvTaskBo;
import com.ruoyi.wms.domain.dto.pda.*;
import com.ruoyi.wms.domain.entity.*;
import com.ruoyi.wms.domain.vo.AgvTaskVo;
import com.ruoyi.wms.domain.vo.PalletVo;
import com.ruoyi.wms.domain.vo.ValveVo;
import com.ruoyi.wms.mapper.*;
import com.ruoyi.wms.service.*;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

/**
 * PDA接口控制器
 *
 * @author wms
 * @date 2025-01-15
 */
@Slf4j
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/api")
public class PdaApiController {

    private final SysLoginService loginService;
    private final SysUserService userService;
    private final BarcodeService barcodeService;
    private final PalletService palletService;
    private final PalletTypeService palletTypeService;
    private final ValveService valveService;
    private final AgvTaskService agvTaskService;
    private final BinService binService;
    private final AgvOpenTaskService agvOpenTaskService;
    private final WmsConfigService wmsConfigService;
    private final PalletMapper palletMapper;
    private final ValveMapper valveMapper;
    private final AgvTaskMapper agvTaskMapper;

    /**
     * Token有效期（秒），默认24小时
     */
    @Value("${sa-token.timeout:86400}")
    private long tokenTimeout;

    /**
     * 库前置换区站点编码配置（可以从配置表读取，这里先使用默认值）
     */
    @Value("${wms.swap-station.default:WAREHOUSE_SWAP_1}")
    private String defaultSwapStation;

    private static final String PALLET_SCAN_CONFIG_KEY = "pda.pallet_scan.enabled";
    private static final String AGV_TASK_TYPE_PICK_AND_DROP = "01";
    private static final String AGV_TASK_LEVEL_NORMAL = "2";
    private static final String TASK_SOURCE_PDA = "PDA";

    /**
     * 登录接口
     */
    @SaIgnore
    @PostMapping("/auth/login")
    public R<PdaLoginResponse> login(@Valid @RequestBody PdaLoginRequest request) {
        try {
            // 调用PDA专用登录服务（不验证验证码）
            String token = loginService.pdaLogin(request.getUsername(), request.getPassword());

            // 获取用户信息
            LoginUser loginUser = LoginHelper.getLoginUser(token);
            SysUserVo user = userService.selectUserById(loginUser.getUserId());

            // 构建响应
            PdaLoginResponse response = new PdaLoginResponse();
            response.setToken(token);
            
            // 计算过期时间（当前时间 + token有效期）
            LocalDateTime expireTime = LocalDateTime.now().plusSeconds(tokenTimeout);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            response.setExpireAt(sdf.format(Date.from(expireTime.atZone(ZoneId.systemDefault()).toInstant())));
            
            response.setUserName(user.getNickName() != null ? user.getNickName() : user.getUserName());
            
            // 获取用户角色
            List<String> roles = new ArrayList<>();
            if (loginUser.getRolePermission() != null) {
                roles.addAll(loginUser.getRolePermission());
            }
            // 如果没有角色，默认添加PDA_USER
            if (roles.isEmpty()) {
                roles.add("PDA_USER");
            }
            response.setRoles(roles);

            return R.ok(response);
        } catch (UserException e) {
            // 用户相关异常（用户不存在、账号停用等）
            log.warn("PDA登录失败: {}", e.getMessage());
            return R.fail(400, e.getMessage() != null ? e.getMessage() : "用户名或密码错误");
        } catch (Exception e) {
            // 其他异常
            log.error("PDA登录失败", e);
            return R.fail(400, "用户名或密码错误");
        }
    }

    /**
     * 托盘扫码开关配置
     */
    @PostMapping("/pallet/scan/config")
    public R<PdaPalletScanConfigResponse> palletScanConfig(@Valid @RequestBody PdaPalletScanConfigRequest request) {
        PdaPalletScanConfigResponse response = new PdaPalletScanConfigResponse();
        response.setEnabled(isPalletScanEnabled());
        return R.ok(response);
    }

    /**
     * 托盘类型列表（仅返回启用的类型）
     */
    @PostMapping("/pallet/type/list")
    public R<List<PdaPalletTypeResponse>> listPalletTypes() {
        try {
            List<PalletType> typeList = palletTypeService.list(Wrappers.<PalletType>lambdaQuery()
                .eq(PalletType::getStatus, "0")
                .orderByAsc(PalletType::getTypeCode));
            List<PdaPalletTypeResponse> result = typeList.stream()
                .map(type -> {
                    PdaPalletTypeResponse item = new PdaPalletTypeResponse();
                    item.setId(type.getId());
                    item.setTypeCode(type.getTypeCode());
                    item.setTypeName(type.getTypeName());
                    return item;
                })
                .collect(Collectors.toList());
            return R.ok(result);
        } catch (Exception e) {
            log.error("获取托盘类型失败", e);
            return R.fail(500, "获取托盘类型失败: " + e.getMessage());
        }
    }

    /**
     * 托盘扫码接口
     */
    @PostMapping("/pallet/scan")
    public R<PdaPalletScanResponse> scanPallet(@Valid @RequestBody PdaPalletScanRequest request) {
        try {
            // 查询条码信息
            var barcodeVo = barcodeService.queryByBarcode(request.getBarcode());
            if (barcodeVo == null) {
                return R.fail(404, "托盘不存在");
            }

            // 查询托盘信息
            PalletVo palletVo = palletService.queryByPalletCode(barcodeVo.getObjectCode());
            if (palletVo == null) {
                return R.fail(404, "托盘不存在");
            }

            // 查询托盘类型
            PalletType palletType = null;
            if (palletVo.getPalletTypeId() != null) {
                palletType = palletTypeService.getById(palletVo.getPalletTypeId());
            }

            // 构建响应
            PdaPalletScanResponse response = new PdaPalletScanResponse();
            response.setPalletNo(palletVo.getPalletCode());
            
            // 转换托盘类型：SMALL或LARGE
            String palletTypeCode = "SMALL"; // 默认小托盘
            if (palletType != null && palletType.getTypeCode() != null) {
                String typeCode = palletType.getTypeCode().toUpperCase();
                if (typeCode.contains("LARGE") || typeCode.contains("大")) {
                    palletTypeCode = "LARGE";
                } else if (typeCode.contains("SMALL") || typeCode.contains("小")) {
                    palletTypeCode = "SMALL";
                }
            }
            response.setPalletType(palletTypeCode);
            
            // 库前置换区站点编码（可以从配置或Bin表获取，这里先使用默认值）
            response.setSwapStation(defaultSwapStation);
            
            response.setBinCode(palletVo.getCurrentBinCode());

            return R.ok(response);
        } catch (Exception e) {
            log.error("托盘扫码失败", e);
            return R.fail(500, "托盘扫码失败: " + e.getMessage());
        }
    }

    /**
     * 获取可用托盘（按托盘编号升序）
     */
    @PostMapping("/pallet/available")
    public R<PdaPalletAvailableResponse> getAvailablePallet(@Valid @RequestBody PdaPalletAvailableRequest request) {
        try {
            PalletVo palletVo = palletService.queryFirstAvailableByType(request.getPalletTypeId());
            if (palletVo == null) {
                return R.fail(404, "无可用托盘");
            }
            if (StrUtil.isBlank(palletVo.getCurrentBinCode())) {
                return R.fail(404, "托盘库位为空");
            }
            PdaPalletAvailableResponse response = new PdaPalletAvailableResponse();
            response.setPalletNo(palletVo.getPalletCode());
            response.setBinCode(palletVo.getCurrentBinCode());
            return R.ok(response);
        } catch (Exception e) {
            log.error("获取可用托盘失败", e);
            return R.fail(500, "获取可用托盘失败: " + e.getMessage());
        }
    }

    /**
     * 获取可用库位（托盘扫码不启用时）
     */
    @PostMapping("/bin/available")
    public R<PdaBinAvailableResponse> getAvailableBin(@RequestBody(required = false) PdaBinAvailableRequest request) {
        try {
            Map<String, Object> agvResp = agvOpenTaskService.binInfo(null);
            String code = MapUtil.getStr(agvResp, "code");
            if (!"20000".equals(code)) {
                String message = MapUtil.getStr(agvResp, "message");
                return R.fail(500, StrUtil.emptyToDefault(message, "查询库位信息失败"));
            }
            Object dataObj = agvResp.get("data");
            String selectedBin = selectFirstAvailableBinCode(dataObj);
            if (StrUtil.isBlank(selectedBin)) {
                return R.fail(404, "无可用库位");
            }
            PdaBinAvailableResponse response = new PdaBinAvailableResponse();
            response.setBinCode(selectedBin);
            return R.ok(response);
        } catch (Exception e) {
            log.error("获取可用库位失败", e);
            return R.fail(500, "获取可用库位失败: " + e.getMessage());
        }
    }

    /**
     * 阀门绑定接口
     */
    @PostMapping("/valve/bind")
    @Transactional(rollbackFor = Exception.class)
    public R<Map<String, Object>> bindValve(@Valid @RequestBody PdaValveBindRequest request) {
        try {
            // 校验阀门编号是否已存在
            ValveVo existingValve = valveService.queryByValveNo(request.getValveNo());
            if (existingValve != null) {
                return R.fail(400, "阀门编号已存在");
            }

            // 查询库位信息
            var binVo = binService.queryByBinCode(request.getBinCode());
            if (binVo == null) {
                return R.fail(400, "库位不存在");
            }

            boolean palletScanEnabled = isPalletScanEnabled();

            // 校验托盘是否存在
            PalletVo palletVo = palletService.queryByPalletCode(request.getPalletNo());
            if (palletScanEnabled) {
                if (palletVo == null) {
                    return R.fail(400, "托盘不存在");
                }
                // 校验库位号是否匹配
                if (!request.getBinCode().equals(palletVo.getCurrentBinCode())) {
                    return R.fail(400, "托盘号和库位号不匹配");
                }
            } else {
                if (palletVo == null) {
                    var palletBo = new com.ruoyi.wms.domain.bo.PalletBo();
                    palletBo.setPalletCode(request.getPalletNo());
                    palletBo.setCurrentBinId(binVo.getId());
                    palletBo.setCurrentBinCode(binVo.getBinCode());
                    palletBo.setIsEmpty(1);
                    palletBo.setIsBound(0);
                    palletBo.setStatus("0");
                    palletService.insertByBo(palletBo);
                    palletVo = palletService.queryByPalletCode(request.getPalletNo());
                } else if (!Objects.equals(palletVo.getCurrentBinCode(), request.getBinCode())) {
                    palletService.updatePalletBin(palletVo.getId(), binVo.getId(), binVo.getBinCode());
                    palletVo = palletService.queryByPalletCode(request.getPalletNo());
                }
                if (palletVo == null) {
                    return R.fail(500, "托盘创建失败");
                }
            }

            // 创建阀门实体
            Valve valve = new Valve();
            valve.setValveNo(request.getValveNo());
            valve.setModel(request.getValveModel());
            valve.setManufacturer(request.getVendorName());
            
            // 解析入库日期
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                valve.setProductionDate(sdf.parse(request.getInboundDate()));
            } catch (Exception e) {
                log.warn("入库日期解析失败: {}", request.getInboundDate());
            }

            valve.setPalletId(palletVo.getId());
            valve.setPalletCode(request.getPalletNo());
            valve.setCurrentBinId(binVo.getId());
            valve.setCurrentBinCode(request.getBinCode());
            valve.setStatus(0); // 0:在库（IN_STOCK）

            // 保存阀门
            valveService.insertByBo(MapstructUtils.convert(valve, com.ruoyi.wms.domain.bo.ValveBo.class));

            // 更新托盘绑定状态
            palletService.bindMaterial(palletVo.getId());

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            return R.ok(result);
        } catch (ServiceException e) {
            return R.fail(e.getCode(), e.getMessage());
        } catch (Exception e) {
            log.error("阀门绑定失败", e);
            return R.fail(500, "阀门绑定失败: " + e.getMessage());
        }
    }

    /**
     * 阀门查询接口
     */
    @PostMapping("/valve/query")
    public R<PdaValveQueryResponse> queryValve(@Valid @RequestBody PdaValveQueryRequest request) {
        try {
            // 构建查询条件
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            
            // 厂家名称（模糊查询）
            if (StrUtil.isNotBlank(request.getVendorName())) {
                wrapper.like(Valve::getManufacturer, request.getVendorName());
            }
            
            // 阀门编号（精确查询）
            if (StrUtil.isNotBlank(request.getValveNo())) {
                wrapper.eq(Valve::getValveNo, request.getValveNo());
            }
            
            // 阀门型号（模糊查询）
            if (StrUtil.isNotBlank(request.getValveModel())) {
                wrapper.like(Valve::getModel, request.getValveModel());
            }
            
            // 入库日期
            if (StrUtil.isNotBlank(request.getInboundDate())) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date inboundDate = sdf.parse(request.getInboundDate());
                    wrapper.eq(Valve::getProductionDate, inboundDate);
                } catch (Exception e) {
                    log.warn("入库日期解析失败: {}", request.getInboundDate());
                }
            }
            
            // 阀门状态
            if (StrUtil.isNotBlank(request.getValveStatus())) {
                Integer status = convertValveStatus(request.getValveStatus());
                if (status != null) {
                    wrapper.eq(Valve::getStatus, status);
                }
            }

            // 分页查询
            Page<Valve> page = new Page<>(request.getPageNum(), request.getPageSize());
            Page<Valve> result = valveMapper.selectPage(page, wrapper);

            // 转换为响应DTO
            PdaValveQueryResponse response = new PdaValveQueryResponse();
            List<PdaValveInfo> list = result.getRecords().stream().map(valve -> {
                PdaValveInfo info = new PdaValveInfo();
                info.setValveNo(valve.getValveNo());
                info.setValveModel(valve.getModel());
                info.setVendorName(valve.getManufacturer());
                info.setPalletNo(valve.getPalletCode());
                info.setBinCode(valve.getCurrentBinCode());
                info.setValveStatus(convertValveStatusToString(valve.getStatus()));
                
                // 入库日期
                if (valve.getProductionDate() != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    info.setInboundDate(sdf.format(valve.getProductionDate()));
                }
                
                // 物料编码（可以从物料类型表获取，这里先使用阀门编号）
                info.setMatCode("MAT-" + valve.getValveNo());
                
                return info;
            }).collect(Collectors.toList());

            response.setList(list);
            response.setTotal(result.getTotal());
            response.setPageNum(request.getPageNum());
            response.setPageSize(request.getPageSize());

            return R.ok(response);
        } catch (Exception e) {
            log.error("阀门查询失败", e);
            return R.fail(500, "阀门查询失败: " + e.getMessage());
        }
    }

    /**
     * 任务记录查询接口
     */
    @PostMapping("/task/query")
    public R<PdaTaskQueryResponse> queryTask(@Valid @RequestBody PdaTaskQueryRequest request) {
        try {
            // 构建查询条件
            LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(AgvTask::getTaskSource, TASK_SOURCE_PDA);
            wrapper.eq(AgvTask::getPdaDeviceNo, StrUtil.trimToNull(request.getDeviceCode()));
            
            // 日期范围
            if (StrUtil.isNotBlank(request.getStartDate()) || StrUtil.isNotBlank(request.getEndDate())) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    if (StrUtil.isNotBlank(request.getStartDate())) {
                        Date startDate = sdf.parse(request.getStartDate());
                        wrapper.ge(AgvTask::getCreateTime, startDate);
                    }
                    if (StrUtil.isNotBlank(request.getEndDate())) {
                        Date endDate = sdf.parse(request.getEndDate());
                        // 结束日期需要包含当天，所以加一天
                        Calendar cal = Calendar.getInstance();
                        cal.setTime(endDate);
                        cal.add(Calendar.DAY_OF_MONTH, 1);
                        wrapper.lt(AgvTask::getCreateTime, cal.getTime());
                    }
                } catch (Exception e) {
                    log.warn("日期解析失败: {}", e.getMessage());
                }
            } else {
                // 默认查询当天
                Calendar cal = Calendar.getInstance();
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                cal.set(Calendar.MILLISECOND, 0);
                Date startDate = cal.getTime();
                cal.add(Calendar.DAY_OF_MONTH, 1);
                Date endDate = cal.getTime();
                wrapper.ge(AgvTask::getCreateTime, startDate);
                wrapper.lt(AgvTask::getCreateTime, endDate);
            }
            
            // 任务类型
            if (StrUtil.isNotBlank(request.getTaskType())) {
                Integer taskType = convertTaskType(request.getTaskType());
                if (taskType != null) {
                    wrapper.eq(AgvTask::getTaskType, taskType);
                }
            }
            
            // 任务状态
            if (StrUtil.isNotBlank(request.getStatus())) {
                Integer status = convertTaskStatus(request.getStatus());
                if (status != null) {
                    wrapper.eq(AgvTask::getStatus, status);
                }
            }

            // 分页查询
            Page<AgvTask> page = new Page<>(request.getPageNum(), request.getPageSize());
            Page<AgvTask> result = agvTaskMapper.selectPage(page, wrapper);

            // 转换为响应DTO
            PdaTaskQueryResponse response = new PdaTaskQueryResponse();
            List<PdaTaskInfo> list = result.getRecords().stream().map(task -> {
                PdaTaskInfo info = new PdaTaskInfo();
                info.setOutID(task.getTaskNo());
                info.setTaskType(convertTaskTypeToString(task.getTaskType()));
                info.setStatus(convertTaskStatusToString(task.getStatus()));
                info.setPalletNo(task.getPalletCode());
                
                // 创建时间
                if (task.getCreateTime() != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    info.setCreateTime(sdf.format(task.getCreateTime()));
                }
                
                // 阀门编号和物料编码（可以从关联的阀门表查询，这里先留空）
                // info.setValveNo(...);
                // info.setMatCode(...);
                
                info.setBinCode(task.getToBinCode());

                return info;
            }).collect(Collectors.toList());

            response.setList(list);
            response.setTotal(result.getTotal());
            response.setPageNum(request.getPageNum());
            response.setPageSize(request.getPageSize());

            return R.ok(response);
        } catch (Exception e) {
            log.error("任务查询失败", e);
            return R.fail(500, "任务查询失败: " + e.getMessage());
        }
    }

    /**
     * 任务下发（PDA → WMS → AGV）
     */
    @PostMapping("/task/dispatch")
    public R<PdaTaskDispatchResponse> dispatchTask(@Valid @RequestBody PdaTaskDispatchRequest request) {
        String taskTypeName = request.getTaskType();
        Integer taskType = convertTaskType(taskTypeName);
        if (taskType == null) {
            return R.fail(400, "任务类型不合法");
        }
        if (taskType != 1 && hasActiveInboundTask()) {
            return R.fail(409, "入库任务执行中，请稍后再试");
        }
        String fromBinCode = StrUtil.trimToNull(request.getFromBinCode());
        String toBinCode = StrUtil.trimToNull(request.getToBinCode());
        if (fromBinCode == null || toBinCode == null) {
            return R.fail(400, "起始/目标站点不能为空");
        }

        String deviceCode = StrUtil.trimToNull(request.getDeviceCode());
        AgvTaskBo taskBo = new AgvTaskBo();
        taskBo.setTaskType(taskType);
        taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
        taskBo.setPalletCode(StrUtil.trimToNull(request.getPalletNo()));
        taskBo.setFromBinCode(fromBinCode);
        taskBo.setToBinCode(toBinCode);
        taskBo.setRemark(StrUtil.trimToNull(request.getRemark()));
        taskBo.setTaskSource(TASK_SOURCE_PDA);
        taskBo.setPdaDeviceNo(deviceCode);
        agvTaskService.insertByBo(taskBo);

        String taskNo = taskBo.getTaskNo();
        try {
            AgvOpenTaskBo openTaskBo = buildPickDropTask(taskNo, fromBinCode, toBinCode, request.getMatCode());
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(openTaskBo);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                return R.fail(500, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
            }

            PdaTaskDispatchResponse response = new PdaTaskDispatchResponse();
            response.setOutID(taskNo);
            response.setTaskType(taskTypeName);
            response.setStatus("PENDING");
            return R.ok(response);
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            return R.fail(500, "任务下发失败: " + e.getMessage());
        }
    }

    /**
     * 任务取消（PDA → WMS → AGV）
     */
    @PostMapping("/task/cancel")
    public R<Void> cancelTask(@Valid @RequestBody PdaTaskCancelRequest request) {
        String outId = request.getOutID();
        String deviceCode = StrUtil.trimToNull(request.getDeviceCode());
        try {
            AgvTaskVo taskVo = agvTaskService.queryByTaskNo(outId);
            if (taskVo == null) {
                return R.fail(404, "任务不存在");
            }
            if (!TASK_SOURCE_PDA.equals(taskVo.getTaskSource())
                || !StrUtil.equals(deviceCode, taskVo.getPdaDeviceNo())) {
                return R.fail(403, "无权限取消该任务");
            }
            if (taskVo.getStatus() != null && taskVo.getStatus() != 0) {
                return R.fail(409, "只能取消待执行任务");
            }

            AgvOpenTaskBo openTaskBo = new AgvOpenTaskBo();
            openTaskBo.setTaskType("13");
            openTaskBo.setClearOutId(outId);
            openTaskBo.setOutId(outId);
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(openTaskBo);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                return R.fail(500, StrUtil.emptyToDefault(message, "取消任务失败"));
            }

            agvTaskService.cancelTask(taskVo.getId());
            return R.ok();
        } catch (Exception e) {
            return R.fail(500, "取消任务失败: " + e.getMessage());
        }
    }

    /**
     * 入库任务锁定状态
     */
    @PostMapping("/task/inbound/lock")
    public R<PdaInboundLockResponse> inboundLockStatus() {
        long count = countActiveInboundTasks();
        PdaInboundLockResponse response = new PdaInboundLockResponse();
        response.setLocked(count > 0);
        response.setCount(count);
        return R.ok(response);
    }

    /**
     * 查询AGV信息（PDA → WMS → AGV）
     */
    @PostMapping("/agv/info")
    public R<List<Map<String, Object>>> agvInfo() {
        try {
            Map<String, Object> agvResp = agvOpenTaskService.agvInfo();
            String code = MapUtil.getStr(agvResp, "code");
            if (!"20000".equals(code)) {
                String message = MapUtil.getStr(agvResp, "message");
                return R.fail(500, StrUtil.emptyToDefault(message, "查询AGV信息失败"));
            }
            Object data = agvResp.get("data");
            if (data instanceof List) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> list = (List<Map<String, Object>>) data;
                return R.ok(list);
            }
            return R.ok(Collections.emptyList());
        } catch (Exception e) {
            return R.fail(500, "查询AGV信息失败: " + e.getMessage());
        }
    }

    /**
     * 转换阀门状态枚举为数据库状态值
     */
    private Integer convertValveStatus(String valveStatus) {
        if (valveStatus == null) {
            return null;
        }
        switch (valveStatus.toUpperCase()) {
            case "IN_STOCK":
                return 0; // 在库
            case "IN_INSPECTION":
                return 1; // 检测中
            case "INSPECTED":
                return 2; // 已检测
            case "OUTBOUND":
                return 3; // 已出库
            default:
                return null;
        }
    }

    /**
     * 转换数据库状态值为阀门状态枚举
     */
    private String convertValveStatusToString(Integer status) {
        if (status == null) {
            return null;
        }
        switch (status) {
            case 0:
                return "IN_STOCK";
            case 1:
                return "IN_INSPECTION";
            case 2:
                return "INSPECTED";
            case 3:
                return "OUTBOUND";
            default:
                return null;
        }
    }

    /**
     * 转换任务类型枚举为数据库类型值
     */
    private Integer convertTaskType(String taskType) {
        if (taskType == null) {
            return null;
        }
        switch (taskType.toUpperCase()) {
            case "INBOUND":
                return 1; // 入库任务
            case "SEND_INSPECTION":
                return 2; // 送检任务
            case "RETURN":
                return 3; // 回库任务
            case "OUTBOUND":
                return 4; // 出库任务
            default:
                return null;
        }
    }

    /**
     * 转换数据库类型值为任务类型枚举
     */
    private String convertTaskTypeToString(Integer taskType) {
        if (taskType == null) {
            return null;
        }
        switch (taskType) {
            case 1:
                return "INBOUND";
            case 2:
                return "SEND_INSPECTION";
            case 3:
                return "RETURN";
            case 4:
                return "OUTBOUND";
            default:
                return null;
        }
    }

    /**
     * 转换任务状态枚举为数据库状态值
     */
    private Integer convertTaskStatus(String status) {
        if (status == null) {
            return null;
        }
        switch (status.toUpperCase()) {
            case "PENDING":
                return 0; // 待处理
            case "EXECUTING":
                return 1; // 执行中
            case "COMPLETED":
                return 2; // 已完成
            case "CANCELLED":
                return 4; // 已取消
            case "FAILED":
                return 3; // 失败
            default:
                return null;
        }
    }

    /**
     * 转换数据库状态值为任务状态枚举
     */
    private String convertTaskStatusToString(Integer status) {
        if (status == null) {
            return null;
        }
        switch (status) {
            case 0:
                return "PENDING";
            case 1:
                return "EXECUTING";
            case 2:
                return "COMPLETED";
            case 3:
                return "FAILED";
            case 4:
                return "CANCELLED";
            default:
                return null;
        }
    }

    private boolean isPalletScanEnabled() {
        return wmsConfigService.getBooleanConfig(PALLET_SCAN_CONFIG_KEY, false);
    }

    private boolean hasActiveInboundTask() {
        return countActiveInboundTasks() > 0;
    }

    private long countActiveInboundTasks() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 1);
        wrapper.in(AgvTask::getStatus, 0, 1);
        return agvTaskMapper.selectCount(wrapper);
    }

    private AgvOpenTaskBo buildPickDropTask(String outId, String fromBinCode, String toBinCode, String matCode) {
        AgvOpenTaskBo taskBo = new AgvOpenTaskBo();
        taskBo.setTaskType(AGV_TASK_TYPE_PICK_AND_DROP);
        taskBo.setOutId(outId);
        taskBo.setLevel(AGV_TASK_LEVEL_NORMAL);

        List<AgvOpenTaskBo.AgvTaskPoint> points = new ArrayList<>();
        AgvOpenTaskBo.AgvTaskPoint take = new AgvOpenTaskBo.AgvTaskPoint();
        take.setSn("01");
        take.setPointCode(fromBinCode);
        take.setPointType("02");
        points.add(take);

        AgvOpenTaskBo.AgvTaskPoint drop = new AgvOpenTaskBo.AgvTaskPoint();
        drop.setSn("02");
        drop.setPointCode(toBinCode);
        drop.setPointType("04");
        if (StrUtil.isNotBlank(matCode)) {
            drop.setMatCode(matCode);
        }
        points.add(drop);

        taskBo.setPoints(points);
        return taskBo;
    }

    private String selectFirstAvailableBinCode(Object dataObj) {
        if (dataObj instanceof List<?> list) {
            return list.stream()
                .filter(item -> item instanceof Map)
                .map(item -> (Map<?, ?>) item)
                .filter(item -> "01".equals(MapUtil.getStr(item, "binState")))
                .map(item -> MapUtil.getStr(item, "binCode"))
                .filter(StrUtil::isNotBlank)
                .sorted()
                .findFirst()
                .orElse(null);
        }
        if (dataObj instanceof Map<?, ?> map) {
            String binState = MapUtil.getStr(map, "binState");
            if ("01".equals(binState)) {
                return MapUtil.getStr(map, "binCode");
            }
        }
        return null;
    }
}

