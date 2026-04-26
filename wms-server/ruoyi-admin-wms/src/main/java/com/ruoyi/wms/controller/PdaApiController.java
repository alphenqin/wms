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
import com.ruoyi.wms.domain.bo.PdaOperationBo;
import com.ruoyi.wms.domain.dto.pda.*;
import com.ruoyi.wms.domain.entity.*;
import com.ruoyi.wms.domain.vo.AgvTaskVo;
import com.ruoyi.wms.domain.vo.PalletTypeVo;
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
import org.springframework.scheduling.annotation.Scheduled;

import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
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
    private final PdaOperationService pdaOperationService;
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
    private static final String OUTBOUND_SMALL_PALLET_BIN = "Z3-装卸点";
    private static final String OUTBOUND_LARGE_PALLET_BIN = "Z4-装卸点";
    private static final String OUTBOUND_EMPTY_RETURN_SMALL_START = "Z3-装卸点";
    private static final String OUTBOUND_EMPTY_RETURN_LARGE_START = "Z4-装卸点";
    private static final String PALLET_TYPE_SMALL_CODE = "t1";
    private static final String PALLET_TYPE_LARGE_CODE = "t2";
    private static final String INBOUND_SMALL_LOAD_BIN_1 = "Z1-装卸点";
    private static final String INBOUND_SMALL_LOAD_BIN_2 = "Z2-装卸点";
    private static final String INBOUND_SMALL_LOAD_BIN_3 = "Z3-装卸点";
    private static final String INBOUND_LARGE_LOAD_BIN = "Z4-装卸点";
    private static final String INBOUND_SMALL_DOCK_BIN = "D2-小托盘接驳点";
    private static final String INBOUND_LARGE_DOCK_BIN = "D2-大托盘接驳点";
    private static final String INBOUND_SMALL_BUFFER_BIN = "B3-15-01";
    private static final String INBOUND_LARGE_BUFFER_BIN = "B3-14-01";
    private static final String AGV_RANGE_WIDE = "2";
    private static final String AGV_RANGE_NARROW = "1";
    private static final String INSPECTION_AREA_WAITING = "WAITING";
    private static final String INSPECTION_AREA_FLOW = "FLOW_DEVICE";
    private static final String INSPECTION_AREA_WAITING_LABEL = "待检区";
    private static final String INSPECTION_AREA_FLOW_LABEL = "直排流量装置区";
    private static final String INSPECTION_TARGET_SMALL_WAITING = "F1-检测点";
    private static final String INSPECTION_TARGET_LARGE_WAITING = "F2-检测点";
    private static final String INSPECTION_TARGET_SMALL_FLOW = "F3-检测点";
    private static final String INSPECTION_TARGET_LARGE_FLOW = "F4-检测点";
    private static final String INSPECTION_EMPTY_RETURN_REMARK = "INSPECTION_EMPTY_RETURN";
    private static final String INSPECTION_EMPTY_RETURN_REMARK_LEGACY = "EMPTY_RETURN_FROM_INSPECTION";
    private static final String OUTBOUND_EMPTY_RETURN_REMARK = "OUTBOUND_EMPTY_RETURN";
    private static final String RETURN_CALL_PALLET_REMARK = "RETURN_CALL_PALLET";
    private static final String VALVE_RETURN_REMARK = "VALVE_RETURN";
    private static final String AGV_OPEN_TASK_STATUS_FINISHED = "08";
    private static final String AGV_OPEN_TASK_STATUS_CLEARED = "09";
    private static final long AGV_OPEN_TASK_POLL_INTERVAL_MS = 10_000L;
    private static final long AGV_OPEN_TASK_TIMEOUT_MS = 40L * 60L * 1000L;
    private static final int INBOUND_RESERVED_PALLET_COUNT = 2;
    private static final String INBOUND_QUEUE_REMARK_PREFIX = "INBOUND_QUEUE";

    private final ExecutorService inboundExecutor = Executors.newCachedThreadPool();
    private final Object inboundQueueLock = new Object();

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
                recordOperation(1, request.getDeviceCode(), request.getBarcode(), null, null, 0, null, "托盘不存在");
                return R.fail(404, "托盘不存在");
            }

            // 查询托盘信息
            PalletVo palletVo = palletService.queryByPalletCode(barcodeVo.getObjectCode());
            if (palletVo == null) {
                recordOperation(1, request.getDeviceCode(), request.getBarcode(), null, null, 0, null, "托盘不存在");
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

            recordOperation(1, request.getDeviceCode(), request.getBarcode(), null, null, 1, "托盘扫码成功", null);
            return R.ok(response);
        } catch (Exception e) {
            log.error("托盘扫码失败", e);
            recordOperation(1, request.getDeviceCode(), request.getBarcode(), null, null, 0, null, e.getMessage());
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
     * 托盘置空
     */
    @PostMapping("/pallet/unbind")
    public R<Void> unbindPallet(@Valid @RequestBody PdaPalletUnbindRequest request) {
        try {
            PalletVo palletVo = palletService.queryByPalletCode(request.getPalletNo());
            if (palletVo == null || palletVo.getId() == null) {
                return R.fail(404, "托盘不存在");
            }
            palletService.unbindMaterial(palletVo.getId());
            return R.ok();
        } catch (Exception e) {
            log.error("托盘置空失败", e);
            return R.fail(500, "托盘置空失败: " + e.getMessage());
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
                recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 0, null, "阀门编号已存在");
                return R.fail(400, "阀门编号已存在");
            }

            // 查询库位信息
            var binVo = binService.queryByBinCode(request.getBinCode());
            if (binVo == null) {
                recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 0, null, "库位不存在");
                return R.fail(400, "库位不存在");
            }

            boolean palletScanEnabled = isPalletScanEnabled();

            // 校验托盘是否存在
            PalletVo palletVo = palletService.queryByPalletCode(request.getPalletNo());
            if (palletScanEnabled) {
                if (palletVo == null) {
                    recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 0, null, "托盘不存在");
                    return R.fail(400, "托盘不存在");
                }
                // 校验库位号是否匹配
                if (!request.getBinCode().equals(palletVo.getCurrentBinCode())) {
                    recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 0, null, "托盘号和库位号不匹配");
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
                    recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 0, null, "托盘创建失败");
                    return R.fail(500, "托盘创建失败");
                }
            }

            // 创建阀门实体
            Valve valve = new Valve();
            valve.setValveNo(request.getValveNo());
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
            recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 1, "阀门绑定成功", null);
            return R.ok(result);
        } catch (ServiceException e) {
            recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 0, null, e.getMessage());
            return R.fail(e.getCode(), e.getMessage());
        } catch (Exception e) {
            log.error("阀门绑定失败", e);
            recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 0, null, e.getMessage());
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
                info.setVendorName(valve.getManufacturer());
                info.setPalletNo(valve.getPalletCode());
                info.setBinCode(valve.getCurrentBinCode());
                info.setValveStatus(convertValveStatusToString(valve.getStatus()));
                info.setInspectionTargetBin(valve.getInspectionTargetBin());
                
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
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                    info.setCreateTime(task.getCreateTime().format(formatter));
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
        String requestOutId = StrUtil.trimToNull(request.getOutID());
        String deviceCode = StrUtil.trimToNull(request.getDeviceCode());
        String palletNo = StrUtil.trimToNull(request.getPalletNo());
        String toBinCode = StrUtil.trimToNull(request.getToBinCode());
        if (requestOutId != null) {
            AgvTaskVo existing = agvTaskService.queryByTaskNo(requestOutId);
            if (existing != null) {
                boolean mismatch = false;
                if (existing.getTaskType() != null && !existing.getTaskType().equals(taskType)) {
                    mismatch = true;
                }
                if (deviceCode != null && !StrUtil.equals(deviceCode, existing.getPdaDeviceNo())) {
                    mismatch = true;
                }
                if (palletNo != null && !StrUtil.equals(palletNo, existing.getPalletCode())) {
                    mismatch = true;
                }
                if (toBinCode != null && !StrUtil.equals(toBinCode, existing.getToBinCode())) {
                    mismatch = true;
                }
                if (mismatch) {
                    return R.fail(409, "outID已存在且参数不一致");
                }
                PdaTaskDispatchResponse response = new PdaTaskDispatchResponse();
                response.setOutID(existing.getTaskNo());
                response.setTaskType(convertTaskTypeToString(existing.getTaskType()));
                response.setStatus(convertTaskStatusToString(existing.getStatus()));
                response.setToBinCode(existing.getToBinCode());
                return R.ok(response);
            }
        }
        if (taskType != 1 && isInboundLocked()) {
            return R.fail(409, "入库任务执行中，请稍后再试");
        }
        String fromBinCode = StrUtil.trimToNull(request.getFromBinCode());
        String matCode = StrUtil.trimToNull(request.getMatCode());

        if (taskType == 1) {
            if (palletNo == null) {
                return R.fail(400, "托盘号不能为空");
            }
            if (fromBinCode == null) {
                return R.fail(400, "入库站点不能为空");
            }
            String targetBinCode = toBinCode;
            if (targetBinCode == null) {
                return R.fail(400, "目标站点不能为空");
            }
            String palletType = resolvePalletTypeCode(palletNo);
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            InboundRoute route = buildInboundRoute(palletType, fromBinCode, targetBinCode);
            if (route == null) {
                return R.fail(400, "入库站点与托盘类型不匹配");
            }

            AgvTaskBo taskBo = new AgvTaskBo();
            taskBo.setTaskType(taskType);
            taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
            taskBo.setPalletCode(palletNo);
            taskBo.setFromBinCode(fromBinCode);
            taskBo.setToBinCode(targetBinCode);
            taskBo.setRemark(buildInboundQueueRemark(matCode, request.getRemark()));
            taskBo.setTaskSource(TASK_SOURCE_PDA);
            taskBo.setPdaDeviceNo(StrUtil.trimToNull(request.getDeviceCode()));
            agvTaskService.insertByBo(taskBo);

            String taskNo = taskBo.getTaskNo();
            triggerInboundQueueDispatch();

            PdaTaskDispatchResponse response = new PdaTaskDispatchResponse();
            response.setOutID(taskNo);
            response.setTaskType(taskTypeName);
            response.setStatus("PENDING");
            response.setToBinCode(targetBinCode);
            recordTaskOperation(taskType, deviceCode, palletNo, taskNo, "入库任务已加入队列", 1, null);
            return R.ok(response);
        }

        if (taskType == 2) {
            if (palletNo == null) {
                return R.fail(400, "托盘号不能为空");
            }
            if (fromBinCode == null) {
                return R.fail(400, "起始站点不能为空");
            }
            String area = resolveInspectionArea(request.getInspectionArea(), request.getToBinCode());
            if (area == null) {
                return R.fail(400, "送检目标区域不能为空");
            }
            String palletType = resolvePalletTypeCode(palletNo);
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            String targetBinCode = resolveInspectionTargetBin(area, palletType);
            if (targetBinCode == null) {
                return R.fail(400, "送检目标站点解析失败");
            }
            InspectionRoute route = buildInspectionRoute(palletType, fromBinCode, targetBinCode);
            if (route == null) {
                return R.fail(400, "送检任务参数错误");
            }

            AgvTaskBo taskBo = new AgvTaskBo();
            taskBo.setTaskType(taskType);
            taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
            taskBo.setPalletCode(palletNo);
            taskBo.setFromBinCode(fromBinCode);
            taskBo.setToBinCode(targetBinCode);
            taskBo.setRemark(StrUtil.trimToNull(request.getRemark()));
            taskBo.setTaskSource(TASK_SOURCE_PDA);
            taskBo.setPdaDeviceNo(StrUtil.trimToNull(request.getDeviceCode()));
            agvTaskService.insertByBo(taskBo);

            String taskNo = taskBo.getTaskNo();
            try {
                String step1OutId = buildInspectionStepOutId(taskNo, 1);
                AgvOpenTaskBo first = buildPickDropTask(step1OutId,
                    route.firstStep.fromBinCode,
                    route.firstStep.toBinCode,
                    null,
                    route.firstStep.agvRange);
                Map<String, Object> agvResp = agvOpenTaskService.sendTask(first);
                String code = MapUtil.getStr(agvResp, "code");
                String message = MapUtil.getStr(agvResp, "message");
                if (!"20000".equals(code)) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                    return R.fail(500, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 1, null);
                updateValveInspectionTarget(request.getValveNo(), palletNo, targetBinCode, area);
                updateValveStatus(request.getValveNo(), palletNo, 1); // 更新阀门状态为IN_INSPECTION（检测中）
                dispatchInspectionFollowupSteps(taskNo, route, matCode);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
                return R.fail(500, "任务下发失败: " + e.getMessage());
            }

            PdaTaskDispatchResponse response = new PdaTaskDispatchResponse();
            response.setOutID(taskNo);
            response.setTaskType(taskTypeName);
            response.setStatus("PENDING");
            response.setToBinCode(targetBinCode);
            recordTaskOperation(taskType, deviceCode, palletNo, taskNo, "送检任务下发成功", 1, null);
            return R.ok(response);
        }

        if (taskType == 3 && isReturnCallPalletRequest(request)) {
            if (palletNo == null) {
                return R.fail(400, "托盘号不能为空");
            }
            if (fromBinCode == null) {
                return R.fail(400, "起始站点不能为空");
            }
            String targetBinCode = toBinCode;
            if (targetBinCode == null) {
                targetBinCode = resolveInspectionTargetBinForReturn(request.getValveNo(), palletNo);
            }
            if (targetBinCode == null) {
                return R.fail(400, "送检目标站点未设置");
            }
            String palletType = resolvePalletTypeCode(palletNo);
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            InspectionRoute route = buildReturnCallPalletRoute(palletType, fromBinCode, targetBinCode);
            if (route == null) {
                return R.fail(400, "呼叫托盘参数错误");
            }

            AgvTaskBo taskBo = new AgvTaskBo();
            taskBo.setTaskType(taskType);
            taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
            taskBo.setPalletCode(palletNo);
            taskBo.setFromBinCode(fromBinCode);
            taskBo.setToBinCode(targetBinCode);
            taskBo.setRemark(RETURN_CALL_PALLET_REMARK);
            taskBo.setTaskSource(TASK_SOURCE_PDA);
            taskBo.setPdaDeviceNo(StrUtil.trimToNull(request.getDeviceCode()));
            agvTaskService.insertByBo(taskBo);

            String taskNo = taskBo.getTaskNo();
            try {
                String step1OutId = buildReturnCallPalletStepOutId(taskNo, 1);
                AgvOpenTaskBo first = buildPickDropTask(step1OutId,
                    route.firstStep.fromBinCode,
                    route.firstStep.toBinCode,
                    null,
                    route.firstStep.agvRange);
                Map<String, Object> agvResp = agvOpenTaskService.sendTask(first);
                String code = MapUtil.getStr(agvResp, "code");
                String message = MapUtil.getStr(agvResp, "message");
                if (!"20000".equals(code)) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                    return R.fail(500, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 1, null);
                dispatchReturnCallPalletFollowupSteps(taskNo, route);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
                return R.fail(500, "任务下发失败: " + e.getMessage());
            }

            PdaTaskDispatchResponse response = new PdaTaskDispatchResponse();
            response.setOutID(taskNo);
            response.setTaskType(taskTypeName);
            response.setStatus("PENDING");
            response.setToBinCode(targetBinCode);
            recordTaskOperation(taskType, deviceCode, palletNo, taskNo, "呼叫托盘任务下发成功", 1, null);
            return R.ok(response);
        }

        if (taskType == 3 && isValveReturnRequest(request)) {
            if (palletNo == null) {
                return R.fail(400, "托盘号不能为空");
            }
            String targetBinCode = toBinCode;
            if (targetBinCode == null) {
                return R.fail(400, "目标站点不能为空");
            }
            String inspectionTargetBin = fromBinCode;
            if (inspectionTargetBin == null) {
                inspectionTargetBin = resolveInspectionTargetBinForReturn(request.getValveNo(), palletNo);
            }
            if (inspectionTargetBin == null) {
                return R.fail(400, "送检目标站点未设置");
            }
            String palletType = resolvePalletTypeCode(palletNo);
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            InspectionRoute route = buildValveReturnRoute(palletType, inspectionTargetBin, targetBinCode);
            if (route == null) {
                return R.fail(400, "样品回库参数错误");
            }

            AgvTaskBo taskBo = new AgvTaskBo();
            taskBo.setTaskType(taskType);
            taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
            taskBo.setPalletCode(palletNo);
            taskBo.setFromBinCode(inspectionTargetBin);
            taskBo.setToBinCode(targetBinCode);
            taskBo.setRemark(VALVE_RETURN_REMARK);
            taskBo.setTaskSource(TASK_SOURCE_PDA);
            taskBo.setPdaDeviceNo(StrUtil.trimToNull(request.getDeviceCode()));
            agvTaskService.insertByBo(taskBo);

            String taskNo = taskBo.getTaskNo();
            try {
                String step1OutId = buildValveReturnStepOutId(taskNo, 1);
                AgvOpenTaskBo first = buildPickDropTask(step1OutId,
                    route.firstStep.fromBinCode,
                    route.firstStep.toBinCode,
                    null,
                    route.firstStep.agvRange);
                Map<String, Object> agvResp = agvOpenTaskService.sendTask(first);
                String code = MapUtil.getStr(agvResp, "code");
                String message = MapUtil.getStr(agvResp, "message");
                if (!"20000".equals(code)) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                    return R.fail(500, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 1, null);
                dispatchValveReturnFollowupSteps(taskNo, route, matCode);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
                return R.fail(500, "任务下发失败: " + e.getMessage());
            }

            PdaTaskDispatchResponse response = new PdaTaskDispatchResponse();
            response.setOutID(taskNo);
            response.setTaskType(taskTypeName);
            response.setStatus("PENDING");
            response.setToBinCode(targetBinCode);
            recordTaskOperation(taskType, deviceCode, palletNo, taskNo, "样品回库任务下发成功", 1, null);
            return R.ok(response);
        }

        if (taskType == 3 && isInspectionEmptyReturnRequest(request)) {
            if (palletNo == null) {
                return R.fail(400, "托盘号不能为空");
            }
            String targetBinCode = toBinCode;
            if (targetBinCode == null) {
                return R.fail(400, "目标站点不能为空");
            }
            String palletType = resolvePalletTypeCode(palletNo);
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            String inspectionTargetBin = resolveInspectionTargetBinForReturn(request.getValveNo(), palletNo);
            if (inspectionTargetBin == null) {
                return R.fail(400, "送检目标站点未设置");
            }
            InspectionRoute route = buildInspectionEmptyReturnRoute(palletType, inspectionTargetBin, targetBinCode);
            if (route == null) {
                return R.fail(400, "空托回库参数错误");
            }

            AgvTaskBo taskBo = new AgvTaskBo();
            taskBo.setTaskType(taskType);
            taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
            taskBo.setPalletCode(palletNo);
            taskBo.setFromBinCode(inspectionTargetBin);
            taskBo.setToBinCode(targetBinCode);
            taskBo.setRemark(INSPECTION_EMPTY_RETURN_REMARK);
            taskBo.setTaskSource(TASK_SOURCE_PDA);
            taskBo.setPdaDeviceNo(StrUtil.trimToNull(request.getDeviceCode()));
            agvTaskService.insertByBo(taskBo);

            String taskNo = taskBo.getTaskNo();
            try {
                String step1OutId = buildInspectionEmptyReturnStepOutId(taskNo, 1);
                AgvOpenTaskBo first = buildPickDropTask(step1OutId,
                    route.firstStep.fromBinCode,
                    route.firstStep.toBinCode,
                    null,
                    route.firstStep.agvRange);
                Map<String, Object> agvResp = agvOpenTaskService.sendTask(first);
                String code = MapUtil.getStr(agvResp, "code");
                String message = MapUtil.getStr(agvResp, "message");
                if (!"20000".equals(code)) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                    return R.fail(500, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 1, null);
                dispatchInspectionEmptyReturnFollowupSteps(taskNo, route);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
                return R.fail(500, "任务下发失败: " + e.getMessage());
            }

            PdaTaskDispatchResponse response = new PdaTaskDispatchResponse();
            response.setOutID(taskNo);
            response.setTaskType(taskTypeName);
            response.setStatus("PENDING");
            response.setToBinCode(targetBinCode);
            recordTaskOperation(taskType, deviceCode, palletNo, taskNo, "送检空托回库任务下发成功", 1, null);
            return R.ok(response);
        }
        if (taskType == 3 && isOutboundEmptyReturnRequest(request)) {
            if (palletNo == null) {
                return R.fail(400, "托盘号不能为空");
            }
            String targetBinCode = toBinCode;
            if (targetBinCode == null) {
                return R.fail(400, "目标站点不能为空");
            }
            String palletType = resolvePalletTypeCode(palletNo);
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            String startBinCode = resolveOutboundEmptyReturnStartBin(palletNo);
            if (startBinCode == null) {
                return R.fail(400, "托盘类型错误");
            }
            InspectionRoute route = buildOutboundEmptyReturnRoute(palletType, startBinCode, targetBinCode);
            if (route == null) {
                return R.fail(400, "空托回库参数错误");
            }

            AgvTaskBo taskBo = new AgvTaskBo();
            taskBo.setTaskType(taskType);
            taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
            taskBo.setPalletCode(palletNo);
            taskBo.setFromBinCode(startBinCode);
            taskBo.setToBinCode(targetBinCode);
            taskBo.setRemark(OUTBOUND_EMPTY_RETURN_REMARK);
            taskBo.setTaskSource(TASK_SOURCE_PDA);
            taskBo.setPdaDeviceNo(StrUtil.trimToNull(request.getDeviceCode()));
            agvTaskService.insertByBo(taskBo);

            String taskNo = taskBo.getTaskNo();
            try {
                String step1OutId = buildOutboundEmptyReturnStepOutId(taskNo, 1);
                AgvOpenTaskBo first = buildPickDropTask(step1OutId,
                    route.firstStep.fromBinCode,
                    route.firstStep.toBinCode,
                    null,
                    route.firstStep.agvRange);
                Map<String, Object> agvResp = agvOpenTaskService.sendTask(first);
                String code = MapUtil.getStr(agvResp, "code");
                String message = MapUtil.getStr(agvResp, "message");
                if (!"20000".equals(code)) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                    return R.fail(500, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 1, null);
                dispatchOutboundEmptyReturnFollowupSteps(taskNo, route);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
                return R.fail(500, "任务下发失败: " + e.getMessage());
            }

            PdaTaskDispatchResponse response = new PdaTaskDispatchResponse();
            response.setOutID(taskNo);
            response.setTaskType(taskTypeName);
            response.setStatus("PENDING");
            response.setToBinCode(targetBinCode);
            recordTaskOperation(taskType, deviceCode, palletNo, taskNo, "出库空托回库任务下发成功", 1, null);
            return R.ok(response);
        }

        if (taskType == 4) {
            if (palletNo == null) {
                return R.fail(400, "托盘号不能为空");
            }
            String palletType = resolvePalletTypeCode(palletNo);
            if (palletType == null) {
                return R.fail(400, "托盘类型不支持");
            }
            String targetBinCode = resolveOutboundToBinCode(palletNo);
            if (targetBinCode == null) {
                return R.fail(400, "托盘类型不支持");
            }
            if (fromBinCode == null) {
                return R.fail(400, "起始站点不能为空");
            }
            OutboundRoute route = buildOutboundRoute(palletType, fromBinCode, targetBinCode);
            if (route == null) {
                return R.fail(400, "出库任务参数错误");
            }

            AgvTaskBo taskBo = new AgvTaskBo();
            taskBo.setTaskType(taskType);
            taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
            taskBo.setPalletCode(palletNo);
            taskBo.setFromBinCode(fromBinCode);
            taskBo.setToBinCode(targetBinCode);
            taskBo.setRemark(StrUtil.trimToNull(request.getRemark()));
            taskBo.setTaskSource(TASK_SOURCE_PDA);
            taskBo.setPdaDeviceNo(StrUtil.trimToNull(request.getDeviceCode()));
            agvTaskService.insertByBo(taskBo);

            String taskNo = taskBo.getTaskNo();
            try {
                String step1OutId = buildOutboundStepOutId(taskNo, 1);
                AgvOpenTaskBo first = buildPickDropTask(step1OutId,
                    route.firstStep.fromBinCode,
                    route.firstStep.toBinCode,
                    null,
                    route.firstStep.agvRange);
                Map<String, Object> agvResp = agvOpenTaskService.sendTask(first);
                String code = MapUtil.getStr(agvResp, "code");
                String message = MapUtil.getStr(agvResp, "message");
                if (!"20000".equals(code)) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                    return R.fail(500, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 1, null);
                dispatchOutboundFollowupSteps(taskNo, route, matCode, palletNo);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
                return R.fail(500, "任务下发失败: " + e.getMessage());
            }

            PdaTaskDispatchResponse response = new PdaTaskDispatchResponse();
            response.setOutID(taskNo);
            response.setTaskType(taskTypeName);
            response.setStatus("PENDING");
            response.setToBinCode(targetBinCode);
            recordTaskOperation(taskType, deviceCode, palletNo, taskNo, "出库任务下发成功", 1, null);
            return R.ok(response);
        }
        if (fromBinCode == null || toBinCode == null) {
            return R.fail(400, "起始/目标站点不能为空");
        }

        AgvTaskBo taskBo = new AgvTaskBo();
        taskBo.setTaskType(taskType);
        taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
        taskBo.setPalletCode(palletNo);
        taskBo.setFromBinCode(fromBinCode);
        taskBo.setToBinCode(toBinCode);
        taskBo.setRemark(StrUtil.trimToNull(request.getRemark()));
        taskBo.setTaskSource(TASK_SOURCE_PDA);
        taskBo.setPdaDeviceNo(deviceCode);
        agvTaskService.insertByBo(taskBo);

        String taskNo = taskBo.getTaskNo();
        try {
            String agvRange = StrUtil.trimToNull(request.getAgvRange());
            AgvOpenTaskBo openTaskBo = buildPickDropTask(taskNo, fromBinCode, toBinCode, matCode, agvRange);
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
            response.setToBinCode(toBinCode);
            recordTaskOperation(taskType, deviceCode, palletNo, taskNo, "任务下发成功", 1, null);
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
                recordOperation(9, deviceCode, outId, outId, null, 0, null, "任务不存在");
                return R.fail(404, "任务不存在");
            }
            if (!TASK_SOURCE_PDA.equals(taskVo.getTaskSource())
                || !StrUtil.equals(deviceCode, taskVo.getPdaDeviceNo())) {
                recordOperation(9, deviceCode, outId, outId, null, 0, null, "无权限取消该任务");
                return R.fail(403, "无权限取消该任务");
            }
            if (taskVo.getStatus() != null && taskVo.getStatus() != 0) {
                recordOperation(9, deviceCode, outId, outId, null, 0, null, "只能取消待执行任务");
                return R.fail(409, "只能取消待执行任务");
            }

            agvTaskService.cancelTaskWithAgv(taskVo.getId());
            if (taskVo.getTaskType() != null && taskVo.getTaskType() == 1) {
                triggerInboundQueueDispatch();
            }
            recordOperation(9, deviceCode, outId, outId, null, 1, "任务取消成功", null);
            return R.ok();
        } catch (Exception e) {
            recordOperation(9, deviceCode, outId, outId, null, 0, null, e.getMessage());
            return R.fail(500, "取消任务失败: " + e.getMessage());
        }
    }

    private void recordTaskOperation(Integer taskType, String pdaDeviceNo, String palletNo, String outId,
                                     String resultMsg, Integer result, String errorMsg) {
        Integer operationType = mapTaskTypeToOperationType(taskType);
        if (operationType == null) {
            return;
        }
        recordOperation(operationType, pdaDeviceNo, palletNo, outId, null, result, resultMsg, errorMsg);
    }

    private Integer mapTaskTypeToOperationType(Integer taskType) {
        if (taskType == null) {
            return null;
        }
        if (taskType == 1) {
            return 4; // 入库
        }
        if (taskType == 2) {
            return 6; // 送检
        }
        if (taskType == 3) {
            return 7; // 回库（含呼叫托盘/空托回库/样品回库）
        }
        if (taskType == 4) {
            return 5; // 出库
        }
        return null;
    }

    private void recordOperation(Integer operationType, String pdaDeviceNo, String scannedCode, String bizOrderNo,
                                 Long bizOrderId, Integer result, String resultMsg, String errorMsg) {
        try {
            PdaOperationBo bo = new PdaOperationBo();
            bo.setOperationType(operationType);
            bo.setOperator(resolveOperator());
            bo.setPdaDeviceNo(pdaDeviceNo);
            bo.setScannedCode(scannedCode);
            bo.setBizOrderNo(bizOrderNo);
            bo.setBizOrderId(bizOrderId);
            bo.setResult(result);
            bo.setResultMsg(resultMsg);
            bo.setErrorMsg(errorMsg);
            pdaOperationService.insertByBo(bo);
        } catch (Exception e) {
            log.error("记录PDA操作失败", e);
        }
    }

    private String resolveOperator() {
        try {
            LoginUser loginUser = LoginHelper.getLoginUser();
            if (loginUser != null) {
                return loginUser.getUsername();
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    /**
     * 任务锁定状态（统一入口）
     */
    @PostMapping("/task/lock/status")
    public R<PdaTaskLockStatusResponse> taskLockStatus() {
        long inboundCount = countActiveInboundTasks();
        long inspectionCount = countActiveInspectionTasks();
        long inspectionEmptyReturnCount = countActiveInspectionEmptyReturnTasks();
        long returnCallCount = countActiveReturnCallTasks();
        long returnValveCount = countActiveReturnValveTasks();
        long outboundCount = countActiveOutboundTasks();
        long outboundEmptyReturnCount = countActiveOutboundEmptyReturnTasks();

        PdaTaskLockStatusResponse response = new PdaTaskLockStatusResponse();
        response.setInboundCount(inboundCount);
        response.setInspectionCount(inspectionCount);
        response.setInspectionEmptyReturnCount(inspectionEmptyReturnCount);
        response.setReturnCallCount(returnCallCount);
        response.setReturnValveCount(returnValveCount);
        response.setOutboundCount(outboundCount);
        response.setOutboundEmptyReturnCount(outboundEmptyReturnCount);

        response.setInboundLocked(isLockedByLatest(inboundCount, getLatestInboundTask()));
        response.setInspectionLocked(isLockedByLatest(inspectionCount, getLatestInspectionTask()));
        response.setInspectionEmptyReturnLocked(isLockedByLatest(inspectionEmptyReturnCount, getLatestInspectionEmptyReturnTask()));
        response.setReturnCallLocked(isLockedByLatest(returnCallCount, getLatestReturnCallTask()));
        response.setReturnValveLocked(isLockedByLatest(returnValveCount, getLatestReturnValveTask()));
        response.setOutboundLocked(isLockedByLatest(outboundCount, getLatestOutboundTask()));
        response.setOutboundEmptyReturnLocked(isLockedByLatest(outboundEmptyReturnCount, getLatestOutboundEmptyReturnTask()));

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

    private boolean isInboundLocked() {
        return isLockedByLatest(countActiveInboundTasks(), getLatestInboundTask());
    }

    private boolean isInspectionLocked() {
        return isLockedByLatest(countActiveInspectionTasks(), getLatestInspectionTask());
    }

    private boolean isInspectionEmptyReturnLocked() {
        return isLockedByLatest(countActiveInspectionEmptyReturnTasks(), getLatestInspectionEmptyReturnTask());
    }

    private boolean isLockedByLatest(long activeCount, AgvTask latest) {
        if (activeCount > 0) {
            return true;
        }
        if (latest == null) {
            return false;
        }
        Integer status = latest.getStatus();
        if (status == null) {
            return true;
        }
        return status != 2 && status != 3 && status != 4;
    }

    private long countActiveInboundTasks() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 1);
        wrapper.in(AgvTask::getStatus, 0, 1);
        return agvTaskMapper.selectCount(wrapper);
    }

    private long countActiveInspectionTasks() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 2);
        wrapper.in(AgvTask::getStatus, 0, 1);
        return agvTaskMapper.selectCount(wrapper);
    }

    private long countActiveInspectionEmptyReturnTasks() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 3);
        wrapper.in(AgvTask::getRemark, INSPECTION_EMPTY_RETURN_REMARK, INSPECTION_EMPTY_RETURN_REMARK_LEGACY);
        wrapper.in(AgvTask::getStatus, 0, 1);
        return agvTaskMapper.selectCount(wrapper);
    }

    private long countActiveReturnCallTasks() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 3);
        wrapper.eq(AgvTask::getRemark, RETURN_CALL_PALLET_REMARK);
        wrapper.in(AgvTask::getStatus, 0, 1);
        return agvTaskMapper.selectCount(wrapper);
    }

    private long countActiveReturnValveTasks() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 3);
        wrapper.eq(AgvTask::getRemark, VALVE_RETURN_REMARK);
        wrapper.in(AgvTask::getStatus, 0, 1);
        return agvTaskMapper.selectCount(wrapper);
    }

    private long countActiveOutboundTasks() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 4);
        wrapper.in(AgvTask::getStatus, 0, 1);
        return agvTaskMapper.selectCount(wrapper);
    }

    private long countActiveOutboundEmptyReturnTasks() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 3);
        wrapper.eq(AgvTask::getRemark, OUTBOUND_EMPTY_RETURN_REMARK);
        wrapper.in(AgvTask::getStatus, 0, 1);
        return agvTaskMapper.selectCount(wrapper);
    }

    private AgvTask getLatestInboundTask() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 1);
        wrapper.orderByDesc(AgvTask::getCreateTime);
        wrapper.last("limit 1");
        return agvTaskMapper.selectOne(wrapper);
    }

    private AgvTask getLatestInspectionTask() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 2);
        wrapper.orderByDesc(AgvTask::getCreateTime);
        wrapper.last("limit 1");
        return agvTaskMapper.selectOne(wrapper);
    }

    private AgvTask getLatestInspectionEmptyReturnTask() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 3);
        wrapper.in(AgvTask::getRemark, INSPECTION_EMPTY_RETURN_REMARK, INSPECTION_EMPTY_RETURN_REMARK_LEGACY);
        wrapper.orderByDesc(AgvTask::getCreateTime);
        wrapper.last("limit 1");
        return agvTaskMapper.selectOne(wrapper);
    }

    private AgvTask getLatestReturnCallTask() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 3);
        wrapper.eq(AgvTask::getRemark, RETURN_CALL_PALLET_REMARK);
        wrapper.orderByDesc(AgvTask::getCreateTime);
        wrapper.last("limit 1");
        return agvTaskMapper.selectOne(wrapper);
    }

    private AgvTask getLatestReturnValveTask() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 3);
        wrapper.eq(AgvTask::getRemark, VALVE_RETURN_REMARK);
        wrapper.orderByDesc(AgvTask::getCreateTime);
        wrapper.last("limit 1");
        return agvTaskMapper.selectOne(wrapper);
    }

    private AgvTask getLatestOutboundTask() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 4);
        wrapper.orderByDesc(AgvTask::getCreateTime);
        wrapper.last("limit 1");
        return agvTaskMapper.selectOne(wrapper);
    }

    private AgvTask getLatestOutboundEmptyReturnTask() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 3);
        wrapper.eq(AgvTask::getRemark, OUTBOUND_EMPTY_RETURN_REMARK);
        wrapper.orderByDesc(AgvTask::getCreateTime);
        wrapper.last("limit 1");
        return agvTaskMapper.selectOne(wrapper);
    }

    private String resolveOutboundToBinCode(String palletNo) {
        String typeCode = resolvePalletTypeCode(palletNo);
        if (StrUtil.equalsIgnoreCase(typeCode, PALLET_TYPE_SMALL_CODE)) {
            return OUTBOUND_SMALL_PALLET_BIN;
        }
        if (StrUtil.equalsIgnoreCase(typeCode, PALLET_TYPE_LARGE_CODE)) {
            return OUTBOUND_LARGE_PALLET_BIN;
        }
        return null;
    }

    private String resolveOutboundEmptyReturnStartBin(String palletNo) {
        String typeCode = resolvePalletTypeCode(palletNo);
        if (StrUtil.equalsIgnoreCase(typeCode, PALLET_TYPE_SMALL_CODE)) {
            return OUTBOUND_EMPTY_RETURN_SMALL_START;
        }
        if (StrUtil.equalsIgnoreCase(typeCode, PALLET_TYPE_LARGE_CODE)) {
            return OUTBOUND_EMPTY_RETURN_LARGE_START;
        }
        return null;
    }

    private String resolvePalletTypeCode(String palletNo) {
        PalletVo palletVo = palletService.queryByPalletCode(palletNo);
        if (palletVo == null || palletVo.getPalletTypeId() == null) {
            return null;
        }
        PalletType palletType = palletTypeService.getById(palletVo.getPalletTypeId());
        if (palletType == null || palletType.getTypeCode() == null) {
            return null;
        }
        return palletType.getTypeCode();
    }

    private String buildInboundStepOutId(String baseTaskNo, int stepIndex) {
        return baseTaskNo + "-" + stepIndex;
    }

    private void triggerInboundQueueDispatch() {
        CompletableFuture.runAsync(this::tryDispatchNextInboundTask, inboundExecutor);
    }

    @Scheduled(fixedDelayString = "${wms.inbound.queue-pump-interval-ms:15000}")
    public void pumpInboundQueue() {
        tryDispatchNextInboundTask();
    }

    private void tryDispatchNextInboundTask() {
        AgvTask nextTask;
        synchronized (inboundQueueLock) {
            if (countExecutingInboundTasks() > 0) {
                return;
            }
            nextTask = claimNextQueuedInboundTask();
        }
        if (nextTask != null) {
            executeQueuedInboundTask(nextTask);
        }
    }

    private long countExecutingInboundTasks() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 1);
        wrapper.eq(AgvTask::getStatus, 1);
        return agvTaskMapper.selectCount(wrapper);
    }

    private AgvTask claimNextQueuedInboundTask() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(AgvTask::getTaskType, 1);
        wrapper.eq(AgvTask::getStatus, 0);
        wrapper.orderByAsc(AgvTask::getCreateTime);
        wrapper.orderByAsc(AgvTask::getId);
        wrapper.last("limit 1");
        AgvTask task = agvTaskMapper.selectOne(wrapper);
        if (task == null) {
            return null;
        }
        task.setStatus(1);
        task.setDispatchTime(new Date());
        task.setErrorMsg(null);
        agvTaskMapper.updateById(task);
        return task;
    }

    private void executeQueuedInboundTask(AgvTask task) {
        if (task == null) {
            return;
        }
        String taskNo = StrUtil.trimToNull(task.getTaskNo());
        String palletNo = StrUtil.trimToNull(task.getPalletCode());
        String fromBinCode = StrUtil.trimToNull(task.getFromBinCode());
        String targetBinCode = StrUtil.trimToNull(task.getToBinCode());
        if (taskNo == null || palletNo == null || fromBinCode == null || targetBinCode == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "入库任务参数不完整");
            triggerInboundQueueDispatch();
            return;
        }
        String palletType = resolvePalletTypeCode(palletNo);
        if (palletType == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "托盘类型错误");
            triggerInboundQueueDispatch();
            return;
        }
        InboundRoute route = buildInboundRoute(palletType, fromBinCode, targetBinCode);
        if (route == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "入库站点与托盘类型不匹配");
            triggerInboundQueueDispatch();
            return;
        }
        List<PalletVo> reservedEmptyPallets = reserveInboundEmptyPallets(palletType, INBOUND_RESERVED_PALLET_COUNT);
        if (reservedEmptyPallets.isEmpty()) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "空托盘不足");
            triggerInboundQueueDispatch();
            return;
        }
        String emptyPalletFromBin = StrUtil.trimToNull(reservedEmptyPallets.get(0).getCurrentBinCode());
        if (emptyPalletFromBin == null) {
            restoreInboundEmptyPalletsFromVoList(reservedEmptyPallets);
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "空托盘库位为空");
            triggerInboundQueueDispatch();
            return;
        }
        List<Long> reservedPalletIds = reservedEmptyPallets.stream()
            .map(PalletVo::getId)
            .filter(Objects::nonNull)
            .collect(Collectors.toList());
        String matCode = extractInboundMatCode(task.getRemark());
        try {
            String step1OutId = buildInboundStepOutId(taskNo, 1);
            AgvOpenTaskBo first = buildPickDropTask(step1OutId,
                route.firstStep.fromBinCode,
                route.firstStep.toBinCode,
                null,
                route.firstStep.agvRange);
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(first);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                restoreInboundEmptyPallets(reservedPalletIds);
                triggerInboundQueueDispatch();
                return;
            }
            dispatchInboundFollowupSteps(taskNo, route, matCode, emptyPalletFromBin, reservedPalletIds);
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            restoreInboundEmptyPallets(reservedPalletIds);
            triggerInboundQueueDispatch();
        }
    }

    private void dispatchInboundFollowupSteps(String taskNo, InboundRoute route, String matCode,
                                              String emptyPalletFromBin, List<Long> reservedPalletIds) {
        CompletableFuture.runAsync(() -> {
            boolean completed = false;
            try {
                if (!waitForOpenTaskFinished(buildInboundStepOutId(taskNo, 1))) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "入库流程步骤1未完成");
                    return;
                }
                if (!dispatchInboundStep(taskNo, 2, route.secondStep, route.targetBinCode, matCode)) {
                    return;
                }
                InboundStep thirdStep = new InboundStep(route.thirdStep.agvRange, emptyPalletFromBin, route.thirdStep.toBinCode);
                if (!dispatchInboundStep(taskNo, 3, thirdStep, route.targetBinCode, null)) {
                    return;
                }
                if (!dispatchInboundStep(taskNo, 4, route.fourthStep, route.targetBinCode, null)) {
                    return;
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
                completed = true;
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            } finally {
                if (!completed) {
                    restoreInboundEmptyPallets(reservedPalletIds);
                }
                triggerInboundQueueDispatch();
            }
        }, inboundExecutor);
    }

    private String buildInboundQueueRemark(String matCode, String remark) {
        StringBuilder builder = new StringBuilder(INBOUND_QUEUE_REMARK_PREFIX);
        if (StrUtil.isNotBlank(matCode)) {
            builder.append("|matCode=").append(matCode);
        }
        if (StrUtil.isNotBlank(remark)) {
            builder.append("|note=").append(remark.replace("|", "/"));
        }
        return builder.toString();
    }

    private String extractInboundMatCode(String remark) {
        if (StrUtil.isBlank(remark)) {
            return null;
        }
        String[] parts = remark.split("\\|");
        for (String part : parts) {
            if (part.startsWith("matCode=")) {
                return StrUtil.emptyToNull(part.substring("matCode=".length()));
            }
        }
        return null;
    }

    private boolean dispatchInboundStep(String taskNo, int stepIndex, InboundStep step, String targetBinCode, String matCode) {
        try {
            String outId = buildInboundStepOutId(taskNo, stepIndex);
            String dropMatCode = step.toBinCode.equals(targetBinCode) ? matCode : null;
            AgvOpenTaskBo taskBo = buildPickDropTask(outId, step.fromBinCode, step.toBinCode, dropMatCode, step.agvRange);
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(taskBo);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                return false;
            }
            if (!waitForOpenTaskFinished(outId)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "入库流程步骤" + stepIndex + "未完成");
                return false;
            }
            return true;
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            return false;
        }
    }

    private boolean waitForOpenTaskFinished(String outId) {
        long deadline = System.currentTimeMillis() + AGV_OPEN_TASK_TIMEOUT_MS;
        while (System.currentTimeMillis() < deadline) {
            Map<String, Object> resp = agvOpenTaskService.refreshTaskResult(outId);
            String status = MapUtil.getStr(resp, "status");
            if (AGV_OPEN_TASK_STATUS_FINISHED.equals(status)) {
                return true;
            }
            if (AGV_OPEN_TASK_STATUS_CLEARED.equals(status)) {
                return false;
            }
            try {
                Thread.sleep(AGV_OPEN_TASK_POLL_INTERVAL_MS);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return false;
            }
        }
        return false;
    }

    private InboundRoute buildInboundRoute(String palletTypeCode, String fromBinCode, String targetBinCode) {
        boolean isSmall = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_SMALL_CODE);
        boolean isLarge = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_LARGE_CODE);
        if (!isSmall && !isLarge) {
            return null;
        }
        String loadBin = StrUtil.trimToNull(fromBinCode);
        if (loadBin == null) {
            return null;
        }
        if (isSmall) {
            boolean validSmallLoadBin = INBOUND_SMALL_LOAD_BIN_1.equals(loadBin)
                || INBOUND_SMALL_LOAD_BIN_2.equals(loadBin)
                || INBOUND_SMALL_LOAD_BIN_3.equals(loadBin);
            if (!validSmallLoadBin) {
                return null;
            }
        } else if (!INBOUND_LARGE_LOAD_BIN.equals(loadBin)) {
            return null;
        }
        String dockBin = isSmall ? INBOUND_SMALL_DOCK_BIN : INBOUND_LARGE_DOCK_BIN;
        String bufferBin = isSmall ? INBOUND_SMALL_BUFFER_BIN : INBOUND_LARGE_BUFFER_BIN;
        InboundStep first = new InboundStep(AGV_RANGE_WIDE, loadBin, dockBin);
        InboundStep second = new InboundStep(AGV_RANGE_NARROW, bufferBin, targetBinCode);
        InboundStep third = new InboundStep(AGV_RANGE_NARROW, targetBinCode, bufferBin);
        InboundStep fourth = new InboundStep(AGV_RANGE_WIDE, dockBin, loadBin);
        return new InboundRoute(targetBinCode, first, second, third, fourth);
    }

    private String resolveInspectionArea(String inspectionArea, String fallback) {
        String area = StrUtil.trimToNull(inspectionArea);
        if (area == null) {
            area = StrUtil.trimToNull(fallback);
        }
        if (area == null) {
            return null;
        }
        if (StrUtil.equalsIgnoreCase(area, INSPECTION_AREA_WAITING)
            || StrUtil.equals(area, INSPECTION_AREA_WAITING_LABEL)) {
            return INSPECTION_AREA_WAITING;
        }
        if (StrUtil.equalsIgnoreCase(area, INSPECTION_AREA_FLOW)
            || StrUtil.equals(area, INSPECTION_AREA_FLOW_LABEL)) {
            return INSPECTION_AREA_FLOW;
        }
        return null;
    }

    private List<PalletVo> reserveInboundEmptyPallets(String palletTypeCode, int count) {
        if (StrUtil.isBlank(palletTypeCode) || count <= 0) {
            return Collections.emptyList();
        }
        PalletTypeVo palletType = palletTypeService.queryByTypeCode(palletTypeCode);
        if (palletType == null || palletType.getId() == null) {
            return Collections.emptyList();
        }
        List<PalletVo> pallets = palletService.reserveEmptyPalletsByType(palletType.getId(), count);
        if (pallets.size() < count) {
            return Collections.emptyList();
        }
        return pallets;
    }

    private void restoreInboundEmptyPallets(List<Long> reservedPalletIds) {
        if (reservedPalletIds == null || reservedPalletIds.isEmpty()) {
            return;
        }
        palletService.restoreEmptyPallets(reservedPalletIds);
    }

    private void restoreInboundEmptyPalletsFromVoList(List<PalletVo> reservedPallets) {
        if (reservedPallets == null || reservedPallets.isEmpty()) {
            return;
        }
        List<Long> palletIds = reservedPallets.stream()
            .map(PalletVo::getId)
            .filter(Objects::nonNull)
            .collect(Collectors.toList());
        restoreInboundEmptyPallets(palletIds);
    }

    private String resolveInspectionTargetBin(String area, String palletTypeCode) {
        boolean isSmall = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_SMALL_CODE);
        boolean isLarge = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_LARGE_CODE);
        if (!isSmall && !isLarge) {
            return null;
        }
        if (INSPECTION_AREA_WAITING.equalsIgnoreCase(area)) {
            return isSmall ? INSPECTION_TARGET_SMALL_WAITING : INSPECTION_TARGET_LARGE_WAITING;
        }
        if (INSPECTION_AREA_FLOW.equalsIgnoreCase(area)) {
            return isSmall ? INSPECTION_TARGET_SMALL_FLOW : INSPECTION_TARGET_LARGE_FLOW;
        }
        return null;
    }

    private void updateValveInspectionTarget(String valveNo, String palletNo, String targetBinCode, String area) {
        Valve valve = null;
        if (StrUtil.isNotBlank(valveNo)) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getValveNo, valveNo);
            valve = valveMapper.selectOne(wrapper);
        }
        if (valve == null && StrUtil.isNotBlank(palletNo)) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getPalletCode, palletNo);
            wrapper.orderByDesc(Valve::getUpdateTime);
            wrapper.last("limit 1");
            valve = valveMapper.selectOne(wrapper);
        }
        if (valve == null) {
            return;
        }
        Valve update = new Valve();
        update.setId(valve.getId());
        update.setInspectionTargetBin(targetBinCode);
        valveMapper.updateById(update);
    }

    private void updateValveStatus(String valveNo, String palletNo, Integer status) {
        Valve valve = null;
        if (StrUtil.isNotBlank(valveNo)) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getValveNo, valveNo);
            valve = valveMapper.selectOne(wrapper);
        }
        if (valve == null && StrUtil.isNotBlank(palletNo)) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getPalletCode, palletNo);
            wrapper.orderByDesc(Valve::getUpdateTime);
            wrapper.last("limit 1");
            valve = valveMapper.selectOne(wrapper);
        }
        if (valve == null) {
            return;
        }
        Valve update = new Valve();
        update.setId(valve.getId());
        update.setStatus(status);
        valveMapper.updateById(update);
    }

    private String buildInspectionStepOutId(String baseTaskNo, int stepIndex) {
        return baseTaskNo + "-S" + stepIndex;
    }

    private String buildOutboundStepOutId(String baseTaskNo, int stepIndex) {
        return baseTaskNo + "-O" + stepIndex;
    }

    private void dispatchInspectionFollowupSteps(String taskNo, InspectionRoute route, String matCode) {
        CompletableFuture.runAsync(() -> {
            try {
                if (!waitForOpenTaskFinished(buildInspectionStepOutId(taskNo, 1))) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "送检流程步骤1未完成");
                    AgvTask task = agvTaskMapper.selectOne(Wrappers.lambdaQuery(AgvTask.class).eq(AgvTask::getTaskNo, taskNo));
                    if (task != null && task.getPalletCode() != null) {
                        updateValveStatus(null, task.getPalletCode(), 0);
                    }
                    return;
                }
                if (!dispatchInspectionStep(taskNo, 2, route.secondStep, route.targetBinCode, matCode)) {
                    return;
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
                // 更新阀门状态为INSPECTED（已检测）
                AgvTask task = agvTaskMapper.selectOne(Wrappers.lambdaQuery(AgvTask.class).eq(AgvTask::getTaskNo, taskNo));
                if (task != null && task.getPalletCode() != null) {
                    updateValveStatus(null, task.getPalletCode(), 2);
                }
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            }
        }, inboundExecutor);
    }

    private boolean dispatchInspectionStep(String taskNo, int stepIndex, InspectionStep step,
                                           String targetBinCode, String matCode) {
        try {
            String outId = buildInspectionStepOutId(taskNo, stepIndex);
            String dropMatCode = step.toBinCode.equals(targetBinCode) ? matCode : null;
            AgvOpenTaskBo taskBo = buildPickDropTask(outId, step.fromBinCode, step.toBinCode, dropMatCode, step.agvRange);
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(taskBo);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                return false;
            }
            if (!waitForOpenTaskFinished(outId)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "送检流程步骤" + stepIndex + "未完成");
                return false;
            }
            return true;
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            return false;
        }
    }

    private void dispatchOutboundFollowupSteps(String taskNo, OutboundRoute route, String matCode, String palletNo) {
        CompletableFuture.runAsync(() -> {
            try {
                if (!waitForOpenTaskFinished(buildOutboundStepOutId(taskNo, 1))) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "出库流程步骤1未完成");
                    return;
                }
                if (!dispatchOutboundStep(taskNo, 2, route.secondStep, route.targetBinCode, matCode)) {
                    return;
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
                unbindPalletSilently(palletNo);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            }
        }, inboundExecutor);
    }

    private boolean dispatchOutboundStep(String taskNo, int stepIndex, OutboundStep step,
                                         String targetBinCode, String matCode) {
        try {
            String outId = buildOutboundStepOutId(taskNo, stepIndex);
            String dropMatCode = step.toBinCode.equals(targetBinCode) ? matCode : null;
            AgvOpenTaskBo taskBo = buildPickDropTask(outId, step.fromBinCode, step.toBinCode, dropMatCode, step.agvRange);
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(taskBo);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                return false;
            }
            if (!waitForOpenTaskFinished(outId)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "出库流程步骤" + stepIndex + "未完成");
                return false;
            }
            return true;
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            return false;
        }
    }

    private InspectionRoute buildInspectionRoute(String palletTypeCode, String fromBinCode, String targetBinCode) {
        boolean isSmall = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_SMALL_CODE);
        boolean isLarge = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_LARGE_CODE);
        if (!isSmall && !isLarge) {
            return null;
        }
        String bufferBin = isSmall ? INBOUND_SMALL_BUFFER_BIN : INBOUND_LARGE_BUFFER_BIN;
        String dockBin = isSmall ? INBOUND_SMALL_DOCK_BIN : INBOUND_LARGE_DOCK_BIN;
        InspectionStep first = new InspectionStep(AGV_RANGE_NARROW, fromBinCode, bufferBin);
        InspectionStep second = new InspectionStep(AGV_RANGE_WIDE, dockBin, targetBinCode);
        return new InspectionRoute(targetBinCode, first, second);
    }

    private InspectionRoute buildReturnCallPalletRoute(String palletTypeCode, String fromBinCode, String targetBinCode) {
        boolean isSmall = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_SMALL_CODE);
        boolean isLarge = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_LARGE_CODE);
        if (!isSmall && !isLarge) {
            return null;
        }
        String bufferBin = isSmall ? INBOUND_SMALL_BUFFER_BIN : INBOUND_LARGE_BUFFER_BIN;
        String dockBin = isSmall ? INBOUND_SMALL_DOCK_BIN : INBOUND_LARGE_DOCK_BIN;
        InspectionStep first = new InspectionStep(AGV_RANGE_NARROW, fromBinCode, bufferBin);
        InspectionStep second = new InspectionStep(AGV_RANGE_WIDE, dockBin, targetBinCode);
        return new InspectionRoute(targetBinCode, first, second);
    }

    private InspectionRoute buildValveReturnRoute(String palletTypeCode, String inspectionTargetBin, String targetBinCode) {
        boolean isSmall = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_SMALL_CODE);
        boolean isLarge = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_LARGE_CODE);
        if (!isSmall && !isLarge) {
            return null;
        }
        String bufferBin = isSmall ? INBOUND_SMALL_BUFFER_BIN : INBOUND_LARGE_BUFFER_BIN;
        String dockBin = isSmall ? INBOUND_SMALL_DOCK_BIN : INBOUND_LARGE_DOCK_BIN;
        InspectionStep first = new InspectionStep(AGV_RANGE_WIDE, inspectionTargetBin, dockBin);
        InspectionStep second = new InspectionStep(AGV_RANGE_NARROW, bufferBin, targetBinCode);
        return new InspectionRoute(targetBinCode, first, second);
    }

    private OutboundRoute buildOutboundRoute(String palletTypeCode, String fromBinCode, String targetBinCode) {
        boolean isSmall = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_SMALL_CODE);
        boolean isLarge = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_LARGE_CODE);
        if (!isSmall && !isLarge) {
            return null;
        }
        String bufferBin = isSmall ? INBOUND_SMALL_BUFFER_BIN : INBOUND_LARGE_BUFFER_BIN;
        String dockBin = isSmall ? INBOUND_SMALL_DOCK_BIN : INBOUND_LARGE_DOCK_BIN;
        OutboundStep first = new OutboundStep(AGV_RANGE_NARROW, fromBinCode, bufferBin);
        OutboundStep second = new OutboundStep(AGV_RANGE_WIDE, dockBin, targetBinCode);
        return new OutboundRoute(targetBinCode, first, second);
    }

    private boolean isInspectionEmptyReturnRequest(PdaTaskDispatchRequest request) {
        String remark = StrUtil.trimToNull(request.getRemark());
        return INSPECTION_EMPTY_RETURN_REMARK.equalsIgnoreCase(remark)
            || INSPECTION_EMPTY_RETURN_REMARK_LEGACY.equalsIgnoreCase(remark);
    }

    private boolean isOutboundEmptyReturnRequest(PdaTaskDispatchRequest request) {
        String remark = StrUtil.trimToNull(request.getRemark());
        return OUTBOUND_EMPTY_RETURN_REMARK.equalsIgnoreCase(remark);
    }

    private boolean isReturnCallPalletRequest(PdaTaskDispatchRequest request) {
        String remark = StrUtil.trimToNull(request.getRemark());
        return RETURN_CALL_PALLET_REMARK.equalsIgnoreCase(remark);
    }

    private boolean isValveReturnRequest(PdaTaskDispatchRequest request) {
        String remark = StrUtil.trimToNull(request.getRemark());
        return VALVE_RETURN_REMARK.equalsIgnoreCase(remark);
    }

    private String resolveInspectionTargetBinForReturn(String valveNo, String palletNo) {
        String target = null;
        Valve valve = null;
        if (StrUtil.isNotBlank(valveNo)) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getValveNo, valveNo);
            valve = valveMapper.selectOne(wrapper);
        }
        if (valve == null && StrUtil.isNotBlank(palletNo)) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getPalletCode, palletNo);
            wrapper.orderByDesc(Valve::getUpdateTime);
            wrapper.last("limit 1");
            valve = valveMapper.selectOne(wrapper);
        }
        if (valve != null) {
            target = StrUtil.trimToNull(valve.getInspectionTargetBin());
        }
        return target;
    }

    private InspectionRoute buildInspectionEmptyReturnRoute(String palletTypeCode, String inspectionTargetBin,
                                                            String targetBinCode) {
        boolean isSmall = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_SMALL_CODE);
        boolean isLarge = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_LARGE_CODE);
        if (!isSmall && !isLarge) {
            return null;
        }
        String dockBin = isSmall ? INBOUND_SMALL_DOCK_BIN : INBOUND_LARGE_DOCK_BIN;
        String bufferBin = isSmall ? INBOUND_SMALL_BUFFER_BIN : INBOUND_LARGE_BUFFER_BIN;
        InspectionStep first = new InspectionStep(AGV_RANGE_WIDE, inspectionTargetBin, dockBin);
        InspectionStep second = new InspectionStep(AGV_RANGE_NARROW, bufferBin, targetBinCode);
        return new InspectionRoute(targetBinCode, first, second);
    }

    private InspectionRoute buildOutboundEmptyReturnRoute(String palletTypeCode, String inspectionTargetBin,
                                                          String targetBinCode) {
        return buildInspectionEmptyReturnRoute(palletTypeCode, inspectionTargetBin, targetBinCode);
    }

    private String buildInspectionEmptyReturnStepOutId(String baseTaskNo, int stepIndex) {
        return baseTaskNo + "-ER" + stepIndex;
    }

    private String buildOutboundEmptyReturnStepOutId(String baseTaskNo, int stepIndex) {
        return baseTaskNo + "-OR" + stepIndex;
    }

    private String buildReturnCallPalletStepOutId(String baseTaskNo, int stepIndex) {
        return baseTaskNo + "-RC" + stepIndex;
    }

    private String buildValveReturnStepOutId(String baseTaskNo, int stepIndex) {
        return baseTaskNo + "-VR" + stepIndex;
    }

    private void dispatchInspectionEmptyReturnFollowupSteps(String taskNo, InspectionRoute route) {
        CompletableFuture.runAsync(() -> {
            try {
                if (!waitForOpenTaskFinished(buildInspectionEmptyReturnStepOutId(taskNo, 1))) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "空托回库步骤1未完成");
                    return;
                }
                if (!dispatchInspectionEmptyReturnStep(taskNo, 2, route.secondStep, route.targetBinCode)) {
                    return;
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            }
        }, inboundExecutor);
    }

    private void dispatchReturnCallPalletFollowupSteps(String taskNo, InspectionRoute route) {
        CompletableFuture.runAsync(() -> {
            try {
                if (!waitForOpenTaskFinished(buildReturnCallPalletStepOutId(taskNo, 1))) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "呼叫托盘步骤1未完成");
                    return;
                }
                if (!dispatchReturnCallPalletStep(taskNo, 2, route.secondStep, route.targetBinCode)) {
                    return;
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            }
        }, inboundExecutor);
    }

    private void dispatchValveReturnFollowupSteps(String taskNo, InspectionRoute route, String matCode) {
        CompletableFuture.runAsync(() -> {
            try {
                if (!waitForOpenTaskFinished(buildValveReturnStepOutId(taskNo, 1))) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "样品回库步骤1未完成");
                    return;
                }
                if (!dispatchValveReturnStep(taskNo, 2, route.secondStep, route.targetBinCode, matCode)) {
                    return;
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            }
        }, inboundExecutor);
    }

    private void dispatchOutboundEmptyReturnFollowupSteps(String taskNo, InspectionRoute route) {
        CompletableFuture.runAsync(() -> {
            try {
                if (!waitForOpenTaskFinished(buildOutboundEmptyReturnStepOutId(taskNo, 1))) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "空托回库步骤1未完成");
                    return;
                }
                if (!dispatchOutboundEmptyReturnStep(taskNo, 2, route.secondStep, route.targetBinCode)) {
                    return;
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            }
        }, inboundExecutor);
    }

    private boolean dispatchInspectionEmptyReturnStep(String taskNo, int stepIndex, InspectionStep step,
                                                      String targetBinCode) {
        try {
            String outId = buildInspectionEmptyReturnStepOutId(taskNo, stepIndex);
            AgvOpenTaskBo taskBo = buildPickDropTask(outId, step.fromBinCode, step.toBinCode, null, step.agvRange);
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(taskBo);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                return false;
            }
            if (!waitForOpenTaskFinished(outId)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "空托回库步骤" + stepIndex + "未完成");
                return false;
            }
            return true;
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            return false;
        }
    }

    private boolean dispatchOutboundEmptyReturnStep(String taskNo, int stepIndex, InspectionStep step,
                                                    String targetBinCode) {
        try {
            String outId = buildOutboundEmptyReturnStepOutId(taskNo, stepIndex);
            AgvOpenTaskBo taskBo = buildPickDropTask(outId, step.fromBinCode, step.toBinCode, null, step.agvRange);
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(taskBo);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                return false;
            }
            if (!waitForOpenTaskFinished(outId)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "空托回库步骤" + stepIndex + "未完成");
                return false;
            }
            return true;
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            return false;
        }
    }

    private boolean dispatchReturnCallPalletStep(String taskNo, int stepIndex, InspectionStep step,
                                                 String targetBinCode) {
        try {
            String outId = buildReturnCallPalletStepOutId(taskNo, stepIndex);
            AgvOpenTaskBo taskBo = buildPickDropTask(outId, step.fromBinCode, step.toBinCode, null, step.agvRange);
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(taskBo);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                return false;
            }
            if (!waitForOpenTaskFinished(outId)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "呼叫托盘步骤" + stepIndex + "未完成");
                return false;
            }
            return true;
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            return false;
        }
    }

    private boolean dispatchValveReturnStep(String taskNo, int stepIndex, InspectionStep step,
                                            String targetBinCode, String matCode) {
        try {
            String outId = buildValveReturnStepOutId(taskNo, stepIndex);
            String dropMatCode = step.toBinCode.equals(targetBinCode) ? matCode : null;
            AgvOpenTaskBo taskBo = buildPickDropTask(outId, step.fromBinCode, step.toBinCode, dropMatCode, step.agvRange);
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(taskBo);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, StrUtil.emptyToDefault(message, "AGV任务下发失败"));
                return false;
            }
            if (!waitForOpenTaskFinished(outId)) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "样品回库步骤" + stepIndex + "未完成");
                return false;
            }
            return true;
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            return false;
        }
    }

    private AgvOpenTaskBo buildPickDropTask(String outId, String fromBinCode, String toBinCode, String matCode, String agvRange) {
        AgvOpenTaskBo taskBo = new AgvOpenTaskBo();
        taskBo.setTaskType(AGV_TASK_TYPE_PICK_AND_DROP);
        taskBo.setOutId(outId);
        taskBo.setLevel(AGV_TASK_LEVEL_NORMAL);
        taskBo.setAgvRange(agvRange);

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

    private void unbindPalletSilently(String palletNo) {
        if (StrUtil.isBlank(palletNo)) {
            return;
        }
        try {
            PalletVo palletVo = palletService.queryByPalletCode(palletNo);
            if (palletVo != null && palletVo.getId() != null) {
                palletService.unbindMaterial(palletVo.getId());
            }
        } catch (Exception e) {
            log.warn("托盘置空失败: {}", e.getMessage());
        }
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

    private static class InboundStep {
        private final String agvRange;
        private final String fromBinCode;
        private final String toBinCode;

        private InboundStep(String agvRange, String fromBinCode, String toBinCode) {
            this.agvRange = agvRange;
            this.fromBinCode = fromBinCode;
            this.toBinCode = toBinCode;
        }
    }

    private static class InboundRoute {
        private final String targetBinCode;
        private final InboundStep firstStep;
        private final InboundStep secondStep;
        private final InboundStep thirdStep;
        private final InboundStep fourthStep;

        private InboundRoute(String targetBinCode, InboundStep firstStep, InboundStep secondStep,
                             InboundStep thirdStep, InboundStep fourthStep) {
            this.targetBinCode = targetBinCode;
            this.firstStep = firstStep;
            this.secondStep = secondStep;
            this.thirdStep = thirdStep;
            this.fourthStep = fourthStep;
        }
    }

    private static class InspectionStep {
        private final String agvRange;
        private final String fromBinCode;
        private final String toBinCode;

        private InspectionStep(String agvRange, String fromBinCode, String toBinCode) {
            this.agvRange = agvRange;
            this.fromBinCode = fromBinCode;
            this.toBinCode = toBinCode;
        }
    }

    private static class OutboundStep {
        private final String agvRange;
        private final String fromBinCode;
        private final String toBinCode;

        private OutboundStep(String agvRange, String fromBinCode, String toBinCode) {
            this.agvRange = agvRange;
            this.fromBinCode = fromBinCode;
            this.toBinCode = toBinCode;
        }
    }

    private static class InspectionRoute {
        private final String targetBinCode;
        private final InspectionStep firstStep;
        private final InspectionStep secondStep;

        private InspectionRoute(String targetBinCode, InspectionStep firstStep, InspectionStep secondStep) {
            this.targetBinCode = targetBinCode;
            this.firstStep = firstStep;
            this.secondStep = secondStep;
        }
    }

    private static class OutboundRoute {
        private final String targetBinCode;
        private final OutboundStep firstStep;
        private final OutboundStep secondStep;

        private OutboundRoute(String targetBinCode, OutboundStep firstStep, OutboundStep secondStep) {
            this.targetBinCode = targetBinCode;
            this.firstStep = firstStep;
            this.secondStep = secondStep;
        }
    }
}
