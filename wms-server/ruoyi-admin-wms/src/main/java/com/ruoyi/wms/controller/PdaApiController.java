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
import com.ruoyi.wms.domain.vo.BinVo;
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

    private static final String PALLET_SCAN_CONFIG_KEY = "pda.pallet_scan.enabled";
    private static final String AGV_TASK_TYPE_PICK_AND_DROP = "01";
    private static final String AGV_TASK_LEVEL_NORMAL = "2";
    private static final String TASK_SOURCE_PDA = "PDA";
    private static final String OUTBOUND_SMALL_PALLET_BIN = "Z6-装卸点";
    private static final String OUTBOUND_LARGE_PALLET_BIN = "Z7-装卸点";
    private static final String OUTBOUND_EMPTY_RETURN_SMALL_START = "Z6-装卸点";
    private static final String OUTBOUND_EMPTY_RETURN_LARGE_START = "Z7-装卸点";
    private static final String PALLET_TYPE_SMALL_CODE = "t1";
    private static final String PALLET_TYPE_LARGE_CODE = "t2";
    private static final String INBOUND_SMALL_LOAD_BIN_1 = "Z1-装卸点";
    private static final String INBOUND_SMALL_LOAD_BIN_2 = "Z2-装卸点";
    private static final String INBOUND_SMALL_LOAD_BIN_3 = "Z3-装卸点";
    private static final String INBOUND_SMALL_LOAD_BIN_4 = "Z4-装卸点";
    private static final String INBOUND_LARGE_LOAD_BIN = "Z5-装卸点";
    private static final String INBOUND_SMALL_DOCK_BIN = "D2-小托盘接驳点";
    private static final String INBOUND_LARGE_DOCK_BIN = "D2-大托盘接驳点";
    private static final String INBOUND_SMALL_BUFFER_BIN = "B3-15-01";
    private static final String INBOUND_LARGE_BUFFER_BIN = "B3-14-01";
    private static final int BIN_TYPE_SMALL_PALLET = 1;
    private static final int BIN_TYPE_LARGE_PALLET = 2;
    private static final List<String> INBOUND_SMALL_PREFERRED_STORAGE_BINS = List.of("B1-1-01", "B1-2-01", "B1-1-02", "B1-1-03");
    private static final List<String> INBOUND_LARGE_PREFERRED_STORAGE_BINS = List.of("B1-13-01", "B1-13-02");
    private static final String AGV_RANGE_WIDE = "2";
    private static final String AGV_RANGE_NARROW = "1";
    private static final String INSPECTION_AREA_WAITING = "WAITING";
    private static final String INSPECTION_AREA_FLOW = "FLOW_DEVICE";
    private static final String INSPECTION_AREA_WAITING_LABEL = "待检区";
    private static final String INSPECTION_AREA_FLOW_LABEL = "直排流量装置区";
    private static final String INSPECTION_TARGET_SMALL_WAITING = "Z6-装卸点";
    private static final String INSPECTION_TARGET_LARGE_WAITING = "Z7-装卸点";
    private static final String INSPECTION_TARGET_SMALL_FLOW = "Z6-装卸点";
    private static final String INSPECTION_TARGET_LARGE_FLOW = "Z7-装卸点";
    private static final String INSPECTION_EMPTY_RETURN_REMARK = "INSPECTION_EMPTY_RETURN";
    private static final String INSPECTION_EMPTY_RETURN_REMARK_LEGACY = "EMPTY_RETURN_FROM_INSPECTION";
    private static final String OUTBOUND_EMPTY_RETURN_REMARK = "OUTBOUND_EMPTY_RETURN";
    private static final String RETURN_CALL_PALLET_REMARK = "RETURN_CALL_PALLET";
    private static final String VALVE_RETURN_REMARK = "VALVE_RETURN";
    private static final String AGV_OPEN_TASK_STATUS_FINISHED = "08";
    private static final String AGV_OPEN_TASK_STATUS_CLEARED = "09";
    private static final long AGV_OPEN_TASK_POLL_INTERVAL_MS = 10_000L;
    private static final long AGV_OPEN_TASK_TIMEOUT_MS = 40L * 60L * 1000L;
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
                String typeCode = palletType.getTypeCode();
                if (isLargePalletType(typeCode)) {
                    palletTypeCode = "LARGE";
                } else if (isSmallPalletType(typeCode)) {
                    palletTypeCode = "SMALL";
                }
            }
            response.setPalletType(palletTypeCode);
            
            response.setSwapStation(palletVo.getOutsideSite());
            
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
     * 根据库外站点获取托盘
     */
    @PostMapping("/pallet/available")
    public R<PdaPalletAvailableResponse> getAvailablePallet(@Valid @RequestBody PdaPalletAvailableRequest request) {
        try {
            PalletVo palletVo = palletService.queryByOutsideSite(request.getOutsideSite());
            if (palletVo == null) {
                return R.fail(404, "该库外站点未找到可用托盘");
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
     * 托盘置空/取消绑定
     */
    @PostMapping("/pallet/unbind")
    @Transactional(rollbackFor = Exception.class)
    public R<Void> unbindPallet(@Valid @RequestBody PdaPalletUnbindRequest request) {
        try {
            String palletNo = StrUtil.trimToNull(request.getPalletNo());
            String valveNo = StrUtil.trimToNull(request.getValveNo());
            String binCode = StrUtil.trimToNull(request.getBinCode());
            if (palletNo == null && valveNo == null) {
                return R.fail(400, "托盘号或出厂编号不能为空");
            }

            boolean unbound = false;
            if (valveNo != null) {
                Valve valve = valveMapper.selectOne(Wrappers.<Valve>lambdaQuery()
                    .eq(Valve::getValveNo, valveNo));
                if (valve != null) {
                    String boundBinCode = StrUtil.blankToDefault(binCode, valve.getCurrentBinCode());
                    valveMapper.deleteById(valve.getId());
                    binService.markEmptyBinIfBoundTo(boundBinCode, valveNo);
                    unbound = true;
                }
            }

            PalletVo palletVo = palletNo == null ? null : palletService.queryByPalletCode(palletNo);
            if (palletVo != null && palletVo.getId() != null) {
                palletService.unbindMaterial(palletVo.getId());
                unbound = true;
            }

            if (!unbound) {
                return R.fail(404, "托盘不存在");
            }
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
            PdaBinAvailableRequest safeRequest = request == null ? new PdaBinAvailableRequest() : request;
            String outsideSite = StrUtil.trimToNull(safeRequest.getOutsideSite());
            if (outsideSite != null && hasActiveInboundTaskAtLoadBin(outsideSite)) {
                return R.fail(409, "该库外站点已有入库/回库任务排队或执行中，请选择其他库外站点");
            }
            Map<String, Object> agvResp = agvOpenTaskService.binInfo(null);
            String code = MapUtil.getStr(agvResp, "code");
            if (!"20000".equals(code)) {
                String message = MapUtil.getStr(agvResp, "message");
                return R.fail(500, StrUtil.emptyToDefault(message, "查询库位信息失败"));
            }
            Object dataObj = agvResp.get("data");
            String selectedBin = selectFirstAvailableBinCode(dataObj, safeRequest);
            if (StrUtil.isBlank(selectedBin)) {
                return R.fail(404, buildNoAvailableBinMessage(safeRequest));
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
            // 校验出厂编号是否已存在
            ValveVo existingValve = valveService.queryByValveNo(request.getValveNo());
            if (existingValve != null) {
                recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 0, null, "出厂编号已存在");
                return R.fail(400, "出厂编号已存在");
            }

            // 查询库位信息
            var binVo = binService.queryByBinCode(request.getBinCode());
            if (binVo == null) {
                recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 0, null, "库位不存在");
                return R.fail(400, "库位不存在");
            }

            String requestPalletNo = StrUtil.trimToNull(request.getPalletNo());
            String requestBinCode = StrUtil.trimToNull(request.getBinCode());
            boolean binCodeCompatPalletNo = Objects.equals(requestPalletNo, requestBinCode);
            String effectivePalletNo = binCodeCompatPalletNo ? null : requestPalletNo;
            boolean palletScanEnabled = isPalletScanEnabled();

            // 托盘编号只作为内部调度字段；库位存放记录以库位+出厂编号为准。
            PalletVo palletVo = effectivePalletNo != null ? palletService.queryByPalletCode(effectivePalletNo) : null;
            if (palletScanEnabled) {
                if (effectivePalletNo != null && palletVo == null) {
                    recordOperation(2, request.getDeviceCode(), request.getValveNo(), null, null, 0, null, "托盘不存在");
                    return R.fail(400, "托盘不存在");
                }
            } else if (effectivePalletNo != null) {
                if (palletVo == null) {
                    var palletBo = new com.ruoyi.wms.domain.bo.PalletBo();
                    palletBo.setPalletCode(effectivePalletNo);
                    palletBo.setCurrentBinId(binVo.getId());
                    palletBo.setCurrentBinCode(binVo.getBinCode());
                    palletBo.setIsEmpty(1);
                    palletBo.setIsBound(0);
                    palletBo.setStatus("0");
                    palletService.insertByBo(palletBo);
                    palletVo = palletService.queryByPalletCode(effectivePalletNo);
                } else if (!Objects.equals(palletVo.getCurrentBinCode(), request.getBinCode())) {
                    palletService.updatePalletBin(palletVo.getId(), binVo.getId(), binVo.getBinCode());
                    palletVo = palletService.queryByPalletCode(effectivePalletNo);
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

            valve.setPalletId(palletVo != null ? palletVo.getId() : null);
            valve.setCurrentBinId(binVo.getId());
            valve.setCurrentBinCode(request.getBinCode());
            valve.setStatus(0); // 0:待检测（IN_STOCK）

            // 保存阀门
            valveService.insertByBo(MapstructUtils.convert(valve, com.ruoyi.wms.domain.bo.ValveBo.class));

            // 库位存放记录以库位+出厂编号为准；托盘状态仅作为内部调度兼容字段维护。
            if (palletVo != null && palletVo.getId() != null) {
                palletService.bindMaterial(palletVo.getId());
            }
            binService.markFullPallet(request.getBinCode(), request.getValveNo());

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
            
            // 出厂编号（模糊查询）
            if (StrUtil.isNotBlank(request.getValveNo())) {
                wrapper.like(Valve::getValveNo, request.getValveNo());
            }
            
            // 入库日期
            if (StrUtil.isNotBlank(request.getInboundDate())) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date inboundDate = sdf.parse(request.getInboundDate());
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(inboundDate);
                    cal.add(Calendar.DAY_OF_MONTH, 1);
                    Date nextDate = cal.getTime();
                    LocalDateTime beginCreateTime = inboundDate.toInstant()
                        .atZone(ZoneId.systemDefault())
                        .toLocalDate()
                        .atStartOfDay();
                    LocalDateTime endCreateTime = beginCreateTime.plusDays(1);
                    wrapper.and(w -> w
                        .ge(Valve::getProductionDate, inboundDate)
                        .lt(Valve::getProductionDate, nextDate)
                        .or(n -> n
                            .isNull(Valve::getProductionDate)
                            .ge(Valve::getCreateTime, beginCreateTime)
                            .lt(Valve::getCreateTime, endCreateTime)));
                } catch (Exception e) {
                    log.warn("入库日期解析失败: {}", request.getInboundDate());
                }
            }
            
            // 阀门状态
            if (StrUtil.isNotBlank(request.getValveStatus())) {
                List<Integer> statuses = Arrays.stream(request.getValveStatus().split(","))
                    .map(StrUtil::trimToNull)
                    .filter(Objects::nonNull)
                    .map(this::convertValveStatus)
                    .filter(Objects::nonNull)
                    .distinct()
                    .collect(Collectors.toList());
                if (!statuses.isEmpty()) {
                    wrapper.in(Valve::getStatus, statuses);
                }
            }
            wrapper.orderByAsc(Valve::getValveNo);

            // 分页查询
            Page<Valve> page = new Page<>(request.getPageNum(), request.getPageSize());
            Page<Valve> result = valveMapper.selectPage(page, wrapper);

            // 转换为响应DTO
            PdaValveQueryResponse response = new PdaValveQueryResponse();
            Map<String, Integer> binTypeCache = new HashMap<>();
            List<PdaValveInfo> list = result.getRecords().stream().map(valve -> {
                PdaValveInfo info = new PdaValveInfo();
                info.setValveNo(valve.getValveNo());
                info.setVendorName(valve.getManufacturer());
                info.setBinCode(valve.getCurrentBinCode());
                info.setBinType(resolveValveBinType(valve, binTypeCache));
                info.setValveStatus(convertValveStatusToString(valve.getStatus()));
                info.setInspectionTargetBin(valve.getInspectionTargetBin());
                info.setRemark(valve.getRemark());
                if (valve.getInspectionDate() != null) {
                    info.setInspectionDate(DateUtil.format(valve.getInspectionDate(), "yyyy-MM-dd"));
                }
                if (valve.getReturnDate() != null) {
                    info.setReturnDate(DateUtil.format(valve.getReturnDate(), "yyyy-MM-dd"));
                }
                
                info.setInboundDate(resolveValveInboundDate(valve));
                
                // 物料编码（可以从物料类型表获取，这里先使用出厂编号）
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

    private String resolveValveInboundDate(Valve valve) {
        if (valve == null) {
            return null;
        }
        if (valve.getProductionDate() != null) {
            return DateUtil.format(valve.getProductionDate(), "yyyy-MM-dd");
        }
        if (valve.getCreateTime() != null) {
            return valve.getCreateTime().format(DateTimeFormatter.ISO_LOCAL_DATE);
        }
        return null;
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
                
                // 出厂编号和物料编码（可以从关联的样品表查询，这里先留空）
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
        boolean valveReturnRequest = taskType == 3 && isValveReturnRequest(request);
        if (taskType != 1 && !valveReturnRequest && isInboundLocked()) {
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
            if (request.getStorageLevel() != null && !isBinOnRequestedLevel(targetBinCode, request.getStorageLevel())) {
                return R.fail(400, "目标库位不是" + formatStorageLevel(request.getStorageLevel()) + "库位");
            }
            if (request.getFirstFloor() != null && !isBinOnRequestedFloor(targetBinCode, request.getFirstFloor())) {
                return R.fail(400, request.getFirstFloor() ? "目标库位不是一层库位" : "目标库位不是二/三层库位");
            }
            if (hasActiveInboundTaskAtTargetBin(targetBinCode)) {
                return R.fail(409, "该目标库位已有入库/回库任务排队或执行中，请重新选择库位");
            }
            String palletType = resolveInboundPalletTypeByLoadBin(fromBinCode);
            if (palletType == null) {
                palletType = resolvePalletTypeCodeFromBinCode(targetBinCode);
            }
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            InboundRoute route = buildInboundRoute(palletType, fromBinCode, targetBinCode);
            if (route == null) {
                return R.fail(400, "入库站点与托盘类型不匹配");
            }
            if (hasActiveInboundTaskAtLoadBin(fromBinCode)) {
                return R.fail(409, "该库外站点已有入库任务排队或执行中，请选择其他库外站点");
            }
            AgvTaskBo taskBo = new AgvTaskBo();
            taskBo.setTaskType(taskType);
            taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
            taskBo.setBizOrderNo(StrUtil.trimToNull(request.getValveNo()));
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
            if (fromBinCode == null) {
                return R.fail(400, "起始站点不能为空");
            }
            String effectivePalletNo = palletNo != null ? palletNo : fromBinCode;
            String palletType = resolvePalletTypeCodeFromBinCode(fromBinCode);
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            String area = resolveInspectionArea(request.getInspectionArea(), request.getToBinCode());
            if (area == null) {
                area = INSPECTION_AREA_WAITING;
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
            taskBo.setBizOrderNo(StrUtil.trimToNull(request.getValveNo()));
            taskBo.setPalletCode(effectivePalletNo);
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
                updateValveInspectionTarget(request.getValveNo(), effectivePalletNo, targetBinCode, area);
                updateValveStatus(request.getValveNo(), effectivePalletNo, 1); // 更新阀门状态为IN_INSPECTION（检测中）
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
            recordTaskOperation(taskType, deviceCode, effectivePalletNo, taskNo, "送检任务下发成功", 1, null);
            return R.ok(response);
        }

        if (taskType == 3 && isReturnCallPalletRequest(request)) {
            if (fromBinCode == null) {
                return R.fail(400, "起始站点不能为空");
            }
            String effectivePalletNo = palletNo != null ? palletNo : fromBinCode;
            String targetBinCode = toBinCode;
            if (targetBinCode == null) {
                targetBinCode = resolveInspectionTargetBinForReturn(request.getValveNo(), effectivePalletNo);
            }
            if (targetBinCode == null) {
                return R.fail(400, "送检目标站点未设置");
            }
            String palletType = resolvePalletTypeCodeFromBinCode(fromBinCode);
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
            taskBo.setBizOrderNo(StrUtil.trimToNull(request.getValveNo()));
            taskBo.setPalletCode(effectivePalletNo);
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
            recordTaskOperation(taskType, deviceCode, effectivePalletNo, taskNo, "呼叫托盘任务下发成功", 1, null);
            return R.ok(response);
        }

        if (taskType == 3 && isValveReturnRequest(request)) {
            String targetBinCode = toBinCode;
            if (targetBinCode == null) {
                return R.fail(400, "目标站点不能为空");
            }
            if (fromBinCode == null) {
                return R.fail(400, "库外站点不能为空");
            }
            if (request.getStorageLevel() != null && !isBinOnRequestedLevel(targetBinCode, request.getStorageLevel())) {
                return R.fail(400, "目标库位不是" + formatStorageLevel(request.getStorageLevel()) + "库位");
            }
            if (hasActiveInboundTaskAtTargetBin(targetBinCode)) {
                return R.fail(409, "该目标库位已有入库/回库任务排队或执行中，请重新选择库位");
            }
            String effectivePalletNo = palletNo != null ? palletNo : targetBinCode;
            String palletType = resolveInboundPalletTypeByLoadBin(fromBinCode);
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            InboundRoute route = buildInboundRoute(palletType, fromBinCode, targetBinCode);
            if (route == null) {
                return R.fail(400, "样品回库参数错误");
            }

            AgvTaskBo taskBo = new AgvTaskBo();
            taskBo.setTaskType(taskType);
            taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
            taskBo.setBizOrderNo(StrUtil.trimToNull(request.getValveNo()));
            taskBo.setPalletCode(effectivePalletNo);
            taskBo.setFromBinCode(fromBinCode);
            taskBo.setToBinCode(targetBinCode);
            taskBo.setRemark(VALVE_RETURN_REMARK);
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
            recordTaskOperation(taskType, deviceCode, effectivePalletNo, taskNo, "样品回库任务已加入队列", 1, null);
            return R.ok(response);
        }

        if (taskType == 3 && isInspectionEmptyReturnRequest(request)) {
            String targetBinCode = toBinCode;
            if (targetBinCode == null) {
                return R.fail(400, "目标站点不能为空");
            }
            String effectivePalletNo = palletNo != null ? palletNo : targetBinCode;
            String palletType = resolvePalletTypeCodeFromBinCode(targetBinCode);
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            String inspectionTargetBin = resolveInspectionTargetBinForReturn(request.getValveNo(), effectivePalletNo);
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
            taskBo.setBizOrderNo(StrUtil.trimToNull(request.getValveNo()));
            taskBo.setPalletCode(effectivePalletNo);
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
            recordTaskOperation(taskType, deviceCode, effectivePalletNo, taskNo, "送检空托回库任务下发成功", 1, null);
            return R.ok(response);
        }
        if (taskType == 3 && isOutboundEmptyReturnRequest(request)) {
            String targetBinCode = toBinCode;
            if (targetBinCode == null) {
                return R.fail(400, "目标站点不能为空");
            }
            String effectivePalletNo = palletNo != null ? palletNo : targetBinCode;
            String palletType = resolvePalletTypeCodeFromBinCode(targetBinCode);
            if (palletType == null) {
                return R.fail(400, "托盘类型错误");
            }
            String startBinCode = resolveOutboundEmptyReturnStartBinByPalletType(palletType);
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
            taskBo.setBizOrderNo(StrUtil.trimToNull(request.getValveNo()));
            taskBo.setPalletCode(effectivePalletNo);
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
            recordTaskOperation(taskType, deviceCode, effectivePalletNo, taskNo, "出库空托回库任务下发成功", 1, null);
            return R.ok(response);
        }

        if (taskType == 4) {
            if (fromBinCode == null) {
                return R.fail(400, "起始站点不能为空");
            }
            String effectivePalletNo = palletNo != null ? palletNo : fromBinCode;
            String palletType = resolvePalletTypeCodeFromBinCode(fromBinCode);
            if (palletType == null) {
                return R.fail(400, "托盘类型不支持");
            }
            String targetBinCode = resolveOutboundToBinCodeByPalletType(palletType);
            if (targetBinCode == null) {
                return R.fail(400, "托盘类型不支持");
            }
            OutboundRoute route = buildOutboundRoute(palletType, fromBinCode, targetBinCode);
            if (route == null) {
                return R.fail(400, "出库任务参数错误");
            }

            AgvTaskBo taskBo = new AgvTaskBo();
            taskBo.setTaskType(taskType);
            taskBo.setTaskNo(StrUtil.trimToNull(request.getOutID()));
            taskBo.setBizOrderNo(StrUtil.trimToNull(request.getValveNo()));
            taskBo.setPalletCode(effectivePalletNo);
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
                dispatchOutboundFollowupSteps(taskNo, route, matCode, request.getValveNo(), effectivePalletNo);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
                return R.fail(500, "任务下发失败: " + e.getMessage());
            }

            PdaTaskDispatchResponse response = new PdaTaskDispatchResponse();
            response.setOutID(taskNo);
            response.setTaskType(taskTypeName);
            response.setStatus("PENDING");
            response.setToBinCode(targetBinCode);
            recordTaskOperation(taskType, deviceCode, effectivePalletNo, taskNo, "出库任务下发成功", 1, null);
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
            if (isInboundOrValveReturnTask(taskVo.getTaskType(), taskVo.getRemark())) {
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
                return 0; // 待检测
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

    private boolean isInboundOrValveReturnTask(Integer taskType, String remark) {
        return Objects.equals(taskType, 1)
            || (Objects.equals(taskType, 3) && VALVE_RETURN_REMARK.equalsIgnoreCase(StrUtil.trimToEmpty(remark)));
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
        wrapper.and(w -> w.eq(AgvTask::getTaskType, 1)
            .or(v -> v.eq(AgvTask::getTaskType, 3).eq(AgvTask::getRemark, VALVE_RETURN_REMARK)));
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
        wrapper.and(w -> w.eq(AgvTask::getTaskType, 1)
            .or(v -> v.eq(AgvTask::getTaskType, 3).eq(AgvTask::getRemark, VALVE_RETURN_REMARK)));
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

    private String resolveOutboundToBinCodeByPalletType(String typeCode) {
        if (StrUtil.equalsIgnoreCase(typeCode, PALLET_TYPE_SMALL_CODE)) {
            return OUTBOUND_SMALL_PALLET_BIN;
        }
        if (StrUtil.equalsIgnoreCase(typeCode, PALLET_TYPE_LARGE_CODE)) {
            return OUTBOUND_LARGE_PALLET_BIN;
        }
        return null;
    }

    private String resolveOutboundEmptyReturnStartBinByPalletType(String typeCode) {
        if (StrUtil.equalsIgnoreCase(typeCode, PALLET_TYPE_SMALL_CODE)) {
            return OUTBOUND_EMPTY_RETURN_SMALL_START;
        }
        if (StrUtil.equalsIgnoreCase(typeCode, PALLET_TYPE_LARGE_CODE)) {
            return OUTBOUND_EMPTY_RETURN_LARGE_START;
        }
        return null;
    }

    private String resolveInboundPalletTypeByLoadBin(String loadBin) {
        if (INBOUND_LARGE_LOAD_BIN.equals(loadBin)) {
            return PALLET_TYPE_LARGE_CODE;
        }
        if (INBOUND_SMALL_LOAD_BIN_1.equals(loadBin)
            || INBOUND_SMALL_LOAD_BIN_2.equals(loadBin)
            || INBOUND_SMALL_LOAD_BIN_3.equals(loadBin)
            || INBOUND_SMALL_LOAD_BIN_4.equals(loadBin)) {
            return PALLET_TYPE_SMALL_CODE;
        }
        return null;
    }

    private String resolvePalletTypeCodeFromBinCode(String binCode) {
        String normalizedBinCode = StrUtil.trimToNull(binCode);
        if (normalizedBinCode == null) {
            return null;
        }
        BinVo bin = binService.queryByBinCode(normalizedBinCode);
        if (bin == null || bin.getBinType() == null) {
            return null;
        }
        if (Objects.equals(bin.getBinType(), BIN_TYPE_SMALL_PALLET)) {
            return PALLET_TYPE_SMALL_CODE;
        }
        if (Objects.equals(bin.getBinType(), BIN_TYPE_LARGE_PALLET)) {
            return PALLET_TYPE_LARGE_CODE;
        }
        return null;
    }

    private Integer resolveValveBinType(Valve valve, Map<String, Integer> binTypeCache) {
        if (valve == null) {
            return null;
        }
        String currentBinCode = StrUtil.trimToNull(valve.getCurrentBinCode());
        if (currentBinCode != null) {
            Integer binType = binTypeCache.computeIfAbsent(currentBinCode, code -> {
                BinVo bin = binService.queryByBinCode(code);
                return bin == null ? null : bin.getBinType();
            });
            if (binType != null) {
                return binType;
            }
        }
        return resolveInspectionTargetBinType(valve.getInspectionTargetBin());
    }

    private Integer resolveInspectionTargetBinType(String inspectionTargetBin) {
        if (StrUtil.equals(inspectionTargetBin, INSPECTION_TARGET_SMALL_WAITING)
            || StrUtil.equals(inspectionTargetBin, INSPECTION_TARGET_SMALL_FLOW)
            || StrUtil.equals(inspectionTargetBin, OUTBOUND_SMALL_PALLET_BIN)) {
            return BIN_TYPE_SMALL_PALLET;
        }
        if (StrUtil.equals(inspectionTargetBin, INSPECTION_TARGET_LARGE_WAITING)
            || StrUtil.equals(inspectionTargetBin, INSPECTION_TARGET_LARGE_FLOW)
            || StrUtil.equals(inspectionTargetBin, OUTBOUND_LARGE_PALLET_BIN)) {
            return BIN_TYPE_LARGE_PALLET;
        }
        return null;
    }

    private boolean isSmallPalletType(String typeCode) {
        if (StrUtil.isBlank(typeCode)) {
            return false;
        }
        String normalized = typeCode.trim().toUpperCase(Locale.ROOT);
        return normalized.startsWith("X")
            || normalized.contains("SMALL")
            || normalized.contains("小")
            || PALLET_TYPE_SMALL_CODE.equalsIgnoreCase(normalized);
    }

    private boolean isLargePalletType(String typeCode) {
        if (StrUtil.isBlank(typeCode)) {
            return false;
        }
        String normalized = typeCode.trim().toUpperCase(Locale.ROOT);
        return normalized.startsWith("D")
            || normalized.contains("LARGE")
            || normalized.contains("大")
            || PALLET_TYPE_LARGE_CODE.equalsIgnoreCase(normalized);
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
        wrapper.and(w -> w.eq(AgvTask::getTaskType, 1)
            .or(v -> v.eq(AgvTask::getTaskType, 3).eq(AgvTask::getRemark, VALVE_RETURN_REMARK)));
        wrapper.eq(AgvTask::getStatus, 1);
        return agvTaskMapper.selectCount(wrapper);
    }

    private AgvTask claimNextQueuedInboundTask() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.and(w -> w.eq(AgvTask::getTaskType, 1)
            .or(v -> v.eq(AgvTask::getTaskType, 3).eq(AgvTask::getRemark, VALVE_RETURN_REMARK)));
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

    private AgvTask claimNextQueuedInboundForChain() {
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.and(w -> w.eq(AgvTask::getTaskType, 1)
            .or(v -> v.eq(AgvTask::getTaskType, 3).eq(AgvTask::getRemark, VALVE_RETURN_REMARK)));
        wrapper.eq(AgvTask::getStatus, 0);
        wrapper.orderByAsc(AgvTask::getCreateTime);
        wrapper.orderByAsc(AgvTask::getId);
        wrapper.last("limit 1");
        AgvTask task = agvTaskMapper.selectOne(wrapper);
        if (task == null) {
            return null;
        }
        if (!Objects.equals(task.getTaskType(), 1)) {
            return null;
        }
        task.setStatus(1);
        task.setDispatchTime(new Date());
        task.setErrorMsg(null);
        agvTaskMapper.updateById(task);
        return task;
    }

    private boolean hasActiveInboundTaskAtLoadBin(String loadBinCode) {
        String normalizedLoadBin = StrUtil.trimToNull(loadBinCode);
        if (normalizedLoadBin == null) {
            return false;
        }
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.and(w -> w.eq(AgvTask::getTaskType, 1)
            .or(v -> v.eq(AgvTask::getTaskType, 3).eq(AgvTask::getRemark, VALVE_RETURN_REMARK)));
        wrapper.in(AgvTask::getStatus, 0, 1);
        wrapper.eq(AgvTask::getFromBinCode, normalizedLoadBin);
        return agvTaskMapper.selectCount(wrapper) > 0;
    }

    private boolean hasActiveInboundTaskAtTargetBin(String targetBinCode) {
        String normalizedTargetBin = StrUtil.trimToNull(targetBinCode);
        if (normalizedTargetBin == null) {
            return false;
        }
        LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
        wrapper.and(w -> w.eq(AgvTask::getTaskType, 1)
            .or(v -> v.eq(AgvTask::getTaskType, 3).eq(AgvTask::getRemark, VALVE_RETURN_REMARK)));
        wrapper.in(AgvTask::getStatus, 0, 1);
        wrapper.eq(AgvTask::getToBinCode, normalizedTargetBin);
        return agvTaskMapper.selectCount(wrapper) > 0;
    }

    private void executeQueuedInboundTask(AgvTask task) {
        if (task == null) {
            return;
        }
        if (Objects.equals(task.getTaskType(), 3)
            && VALVE_RETURN_REMARK.equalsIgnoreCase(StrUtil.trimToEmpty(task.getRemark()))) {
            executeQueuedValveReturnTask(task);
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
        String palletType = resolveInboundPalletTypeByLoadBin(fromBinCode);
        if (palletType == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "入库装卸点错误");
            triggerInboundQueueDispatch();
            return;
        }
        InboundRoute route = buildInboundRoute(palletType, fromBinCode, targetBinCode);
        if (route == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "入库站点与托盘类型不匹配");
            triggerInboundQueueDispatch();
            return;
        }
        String executableTargetBinCode = resolveExecutableInboundTargetBin(task, palletType);
        if (executableTargetBinCode == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "未找到可用入库库位");
            triggerInboundQueueDispatch();
            return;
        }
        if (!Objects.equals(executableTargetBinCode, targetBinCode)) {
            targetBinCode = executableTargetBinCode;
            if (Objects.equals(palletNo, task.getToBinCode())) {
                palletNo = executableTargetBinCode;
            }
            task.setToBinCode(executableTargetBinCode);
            task.setPalletCode(palletNo);
            agvTaskMapper.updateById(task);
            route = buildInboundRoute(palletType, fromBinCode, executableTargetBinCode);
            if (route == null) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "重新分配入库库位失败");
                triggerInboundQueueDispatch();
                return;
            }
        }
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
                triggerInboundQueueDispatch();
                return;
            }
            dispatchInboundFollowupSteps(taskNo, palletNo, route, palletType, matCode);
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            triggerInboundQueueDispatch();
        }
    }

    private void executeQueuedValveReturnTask(AgvTask task) {
        String taskNo = StrUtil.trimToNull(task.getTaskNo());
        String palletNo = StrUtil.trimToNull(task.getPalletCode());
        String fromBinCode = StrUtil.trimToNull(task.getFromBinCode());
        String targetBinCode = StrUtil.trimToNull(task.getToBinCode());
        if (taskNo == null || palletNo == null || fromBinCode == null || targetBinCode == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "回库任务参数不完整");
            triggerInboundQueueDispatch();
            return;
        }
        String palletType = resolveInboundPalletTypeByLoadBin(fromBinCode);
        if (palletType == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "回库装卸点错误");
            triggerInboundQueueDispatch();
            return;
        }
        InboundRoute route = buildInboundRoute(palletType, fromBinCode, targetBinCode);
        if (route == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "回库站点与托盘类型不匹配");
            triggerInboundQueueDispatch();
            return;
        }
        String executableTargetBinCode = resolveExecutableInboundTargetBin(task, palletType);
        if (executableTargetBinCode == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "未找到可用回库库位");
            triggerInboundQueueDispatch();
            return;
        }
        if (!Objects.equals(executableTargetBinCode, targetBinCode)) {
            targetBinCode = executableTargetBinCode;
            if (Objects.equals(palletNo, task.getToBinCode())) {
                palletNo = executableTargetBinCode;
            }
            task.setToBinCode(executableTargetBinCode);
            task.setPalletCode(palletNo);
            agvTaskMapper.updateById(task);
            route = buildInboundRoute(palletType, fromBinCode, executableTargetBinCode);
            if (route == null) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "重新分配回库库位失败");
                triggerInboundQueueDispatch();
                return;
            }
        }
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
                triggerInboundQueueDispatch();
                return;
            }
            dispatchValveReturnFollowupSteps(taskNo, route, palletType, extractInboundMatCode(task.getRemark()),
                task.getBizOrderNo(), palletNo);
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            triggerInboundQueueDispatch();
        }
    }

    private void dispatchInboundFollowupSteps(String taskNo, String inboundPalletNo,
                                              InboundRoute route, String palletTypeCode, String matCode) {
        CompletableFuture.runAsync(() -> {
            try {
                if (!waitForOpenTaskFinished(buildInboundStepOutId(taskNo, 1))) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "入库流程步骤1未完成");
                    return;
                }
                dispatchInboundFollowupAfterFirstStep(taskNo, inboundPalletNo, route, palletTypeCode, matCode);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            } finally {
                triggerInboundQueueDispatch();
            }
        }, inboundExecutor);
    }

    private boolean dispatchInboundFollowupAfterFirstStep(String taskNo, String inboundPalletNo,
                                                          InboundRoute route, String palletTypeCode, String matCode) {
        try {
            PalletVo outboundPallet = resolveNextOutsideReplenishmentPallet(route.firstStep.fromBinCode,
                palletTypeCode, route.targetBinCode, route.secondStep.fromBinCode);
            if (outboundPallet == null || StrUtil.isBlank(outboundPallet.getCurrentBinCode())) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "未找到可补位空托盘");
                return false;
            }
            InboundStep thirdStep = new InboundStep(route.thirdStep.agvRange,
                outboundPallet.getCurrentBinCode(), route.thirdStep.toBinCode);
            if (!dispatchInboundReplenishmentStep(taskNo, 2, route.secondStep, thirdStep,
                route.targetBinCode, matCode)) {
                return false;
            }
            moveInboundPalletInside(inboundPalletNo, route.targetBinCode);
            binService.markFullPallet(route.targetBinCode,
                resolveValveNoForStorage(null, inboundPalletNo, route.targetBinCode));
            binService.markEmptyBin(thirdStep.fromBinCode);

            PreparedInboundTask nextTask = prepareNextQueuedInboundTaskForChainedDispatch();
            if (nextTask != null) {
                int chainedResult = dispatchInboundReturnAndNextStart(taskNo, route.fourthStep, nextTask);
                if (chainedResult == 1) {
                    moveOutboundPalletOutside(outboundPallet, route.firstStep.fromBinCode, route.firstStep.fromBinCode);
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
                    return dispatchInboundFollowupAfterFirstStep(nextTask.taskNo, nextTask.palletNo,
                        nextTask.route, nextTask.palletTypeCode, nextTask.matCode);
                }
                if (chainedResult == -1) {
                    return false;
                }
            }

            if (!dispatchInboundStep(taskNo, 4, route.fourthStep, route.targetBinCode, null)) {
                return false;
            }
            moveOutboundPalletOutside(outboundPallet, route.firstStep.fromBinCode, route.firstStep.fromBinCode);
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
            return true;
        } catch (Exception e) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            return false;
        }
    }

    private PreparedInboundTask prepareNextQueuedInboundTaskForChainedDispatch() {
        AgvTask nextTask;
        synchronized (inboundQueueLock) {
            nextTask = claimNextQueuedInboundForChain();
        }
        if (nextTask == null) {
            return null;
        }
        return prepareInboundTaskForExecution(nextTask);
    }

    private PreparedInboundTask prepareInboundTaskForExecution(AgvTask task) {
        String taskNo = StrUtil.trimToNull(task.getTaskNo());
        String palletNo = StrUtil.trimToNull(task.getPalletCode());
        String fromBinCode = StrUtil.trimToNull(task.getFromBinCode());
        String targetBinCode = StrUtil.trimToNull(task.getToBinCode());
        if (taskNo == null || palletNo == null || fromBinCode == null || targetBinCode == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "入库任务参数不完整");
            return null;
        }
        String palletType = resolveInboundPalletTypeByLoadBin(fromBinCode);
        if (palletType == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "入库装卸点错误");
            return null;
        }
        InboundRoute route = buildInboundRoute(palletType, fromBinCode, targetBinCode);
        if (route == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "入库站点与托盘类型不匹配");
            return null;
        }
        String executableTargetBinCode = resolveExecutableInboundTargetBin(task, palletType);
        if (executableTargetBinCode == null) {
            agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "未找到可用入库库位");
            return null;
        }
        if (!Objects.equals(executableTargetBinCode, targetBinCode)) {
            if (Objects.equals(palletNo, task.getToBinCode())) {
                palletNo = executableTargetBinCode;
            }
            task.setToBinCode(executableTargetBinCode);
            task.setPalletCode(palletNo);
            agvTaskMapper.updateById(task);
            route = buildInboundRoute(palletType, fromBinCode, executableTargetBinCode);
            if (route == null) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "重新分配入库库位失败");
                return null;
            }
        }
        return new PreparedInboundTask(task, taskNo, palletNo, route, palletType, extractInboundMatCode(task.getRemark()));
    }

    private int dispatchInboundReturnAndNextStart(String currentTaskNo, InboundStep currentFourthStep,
                                                  PreparedInboundTask nextTask) {
        String outId = currentTaskNo + "-4-NEXT-" + nextTask.taskNo + "-1";
        AgvOpenTaskBo taskBo = buildContinuousPickDropTask(outId,
            currentFourthStep.fromBinCode,
            currentFourthStep.toBinCode,
            null,
            nextTask.route.firstStep.fromBinCode,
            nextTask.route.firstStep.toBinCode,
            null,
            currentFourthStep.agvRange);
        try {
            Map<String, Object> agvResp = agvOpenTaskService.sendTask(taskBo);
            String code = MapUtil.getStr(agvResp, "code");
            String message = MapUtil.getStr(agvResp, "message");
            if (!"20000".equals(code)) {
                requeueInboundTask(nextTask.task);
                log.warn("入库衔接任务下发失败，回退为单独第4步: currentTaskNo={}, nextTaskNo={}, message={}",
                    currentTaskNo, nextTask.taskNo, message);
                return 0;
            }
            if (!waitForOpenTaskFinished(outId)) {
                agvTaskService.updateTaskStatusByTaskNo(currentTaskNo, 3, "入库衔接任务未完成");
                agvTaskService.updateTaskStatusByTaskNo(nextTask.taskNo, 3, "入库衔接任务未完成");
                return -1;
            }
            return 1;
        } catch (Exception e) {
            requeueInboundTask(nextTask.task);
            log.warn("入库衔接任务异常，回退为单独第4步: currentTaskNo={}, nextTaskNo={}, error={}",
                currentTaskNo, nextTask.taskNo, e.getMessage());
            return 0;
        }
    }

    private void requeueInboundTask(AgvTask task) {
        if (task == null || task.getId() == null) {
            return;
        }
        task.setStatus(0);
        task.setErrorMsg(null);
        agvTaskMapper.updateById(task);
    }

    private String resolveExecutableInboundTargetBin(AgvTask task, String palletTypeCode) {
        String originalTargetBinCode = StrUtil.trimToNull(task.getToBinCode());
        if (originalTargetBinCode == null) {
            return null;
        }
        String valveNo = resolveInboundTaskValveNo(task);
        if (isExecutableInboundTargetBin(originalTargetBinCode, palletTypeCode, valveNo)) {
            return originalTargetBinCode;
        }
        if (valveNo == null) {
            return null;
        }

        PdaBinAvailableRequest request = new PdaBinAvailableRequest();
        request.setPalletType(palletTypeCode);
        request.setStorageLevel(extractBinLevel(originalTargetBinCode));
        String nextTargetBinCode = selectFirstWmsAvailableInboundBinCode(request, palletTypeCode);
        if (StrUtil.isBlank(nextTargetBinCode)) {
            return null;
        }

        binService.markEmptyBinIfBoundTo(originalTargetBinCode, valveNo);
        binService.markFullPallet(nextTargetBinCode, valveNo);
        return nextTargetBinCode;
    }

    private String resolveInboundTaskValveNo(AgvTask task) {
        String valveNo = StrUtil.trimToNull(task.getBizOrderNo());
        if (valveNo != null) {
            return valveNo;
        }
        String matCode = extractInboundMatCode(task.getRemark());
        if (StrUtil.startWithIgnoreCase(matCode, "MAT-")) {
            return StrUtil.trimToNull(matCode.substring("MAT-".length()));
        }
        return null;
    }

    private boolean isExecutableInboundTargetBin(String binCode, String palletTypeCode, String valveNo) {
        BinVo bin = binService.queryByBinCode(binCode);
        if (bin == null || !isWmsBinTypeAllowedForPalletType(bin.getBinType(), palletTypeCode)) {
            return false;
        }
        boolean emptyBin = Objects.equals(bin.getStorageStatus(), BinService.STORAGE_STATUS_EMPTY_BIN)
            && Objects.equals(bin.getStatus(), 0)
            && StrUtil.isBlank(bin.getBoundFactoryNo());
        boolean reservedForCurrentValve = StrUtil.isNotBlank(valveNo)
            && Objects.equals(bin.getStorageStatus(), BinService.STORAGE_STATUS_FULL_PALLET)
            && StrUtil.equals(StrUtil.trimToNull(bin.getBoundFactoryNo()), valveNo);
        return emptyBin || reservedForCurrentValve;
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

    private boolean dispatchInboundReplenishmentStep(String taskNo, int stepIndex, InboundStep inboundStep,
                                                     InboundStep replenishmentStep, String targetBinCode,
                                                     String matCode) {
        try {
            String outId = buildInboundStepOutId(taskNo, stepIndex);
            String dropMatCode = inboundStep.toBinCode.equals(targetBinCode) ? matCode : null;
            AgvOpenTaskBo taskBo = buildContinuousPickDropTask(outId,
                inboundStep.fromBinCode,
                inboundStep.toBinCode,
                dropMatCode,
                replenishmentStep.fromBinCode,
                replenishmentStep.toBinCode,
                null,
                inboundStep.agvRange);
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
                || INBOUND_SMALL_LOAD_BIN_3.equals(loadBin)
                || INBOUND_SMALL_LOAD_BIN_4.equals(loadBin);
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

    private PalletVo resolveNextOutsideReplenishmentPallet(String outsideSite, String palletTypeCode,
                                                           String targetBinCode, String bufferBinCode) {
        if (StrUtil.isBlank(outsideSite) || StrUtil.isBlank(palletTypeCode)) {
            return null;
        }
        PalletTypeVo palletType = palletTypeService.queryByTypeCode(palletTypeCode);
        if (palletType == null || palletType.getId() == null) {
            return null;
        }
        return palletService.queryFirstAvailableByTypeFromCodeAndPreferredLevel(palletType.getId(), null,
            extractBinLevel(targetBinCode), targetBinCode, List.of(targetBinCode, bufferBinCode));
    }

    private void moveInboundPalletInside(String palletNo, String targetBinCode) {
        if (StrUtil.isBlank(palletNo) || StrUtil.isBlank(targetBinCode)) {
            return;
        }
        PalletVo palletVo = palletService.queryByPalletCode(palletNo);
        if (palletVo == null || palletVo.getId() == null) {
            return;
        }
        Long binId = null;
        BinVo binVo = binService.queryByBinCode(targetBinCode);
        if (binVo != null) {
            binId = binVo.getId();
        }
        palletService.updatePalletLocationOutsideSite(palletVo.getId(), binId, targetBinCode, null);
    }

    private void moveOutboundPalletOutside(PalletVo palletVo, String loadBinCode, String outsideSite) {
        if (palletVo == null || palletVo.getId() == null
            || StrUtil.isBlank(loadBinCode) || StrUtil.isBlank(outsideSite)) {
            return;
        }
        palletService.updatePalletLocationOutsideSite(palletVo.getId(), null, loadBinCode, outsideSite);
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

    private String resolveValveNoForStorage(String valveNo, String palletNo, String binCode) {
        String normalizedValveNo = StrUtil.trimToNull(valveNo);
        if (normalizedValveNo != null) {
            return normalizedValveNo;
        }
        String normalizedBinCode = StrUtil.trimToNull(binCode);
        if (normalizedBinCode != null) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getCurrentBinCode, normalizedBinCode);
            wrapper.orderByDesc(Valve::getUpdateTime);
            wrapper.last("limit 1");
            Valve valve = valveMapper.selectOne(wrapper);
            if (valve != null) {
                return StrUtil.trimToNull(valve.getValveNo());
            }
        }
        String normalizedPalletNo = StrUtil.trimToNull(palletNo);
        if (normalizedPalletNo != null) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getCurrentBinCode, normalizedPalletNo);
            wrapper.orderByDesc(Valve::getUpdateTime);
            wrapper.last("limit 1");
            Valve valve = valveMapper.selectOne(wrapper);
            return valve != null ? StrUtil.trimToNull(valve.getValveNo()) : null;
        }
        return null;
    }

    private void updateValveInspectionTarget(String valveNo, String palletNo, String targetBinCode, String area) {
        Valve valve = findValveForWorkflow(valveNo, palletNo);
        if (valve == null) {
            return;
        }
        Valve update = new Valve();
        update.setId(valve.getId());
        update.setInspectionTargetBin(targetBinCode);
        valveMapper.updateById(update);
    }

    private Valve findValveForWorkflow(String valveNo, String palletNo) {
        Valve valve = null;
        if (StrUtil.isNotBlank(valveNo)) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getValveNo, valveNo);
            valve = valveMapper.selectOne(wrapper);
        }
        if (valve == null && StrUtil.isNotBlank(palletNo)) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getCurrentBinCode, palletNo);
            wrapper.orderByDesc(Valve::getUpdateTime);
            wrapper.last("limit 1");
            valve = valveMapper.selectOne(wrapper);
        }
        return valve;
    }

    private void updateValveStatus(String valveNo, String palletNo, Integer status) {
        Valve valve = findValveForWorkflow(valveNo, palletNo);
        if (valve == null) {
            return;
        }
        Valve update = new Valve();
        update.setId(valve.getId());
        update.setStatus(status);
        if (Objects.equals(status, 1)) {
            update.setInspectionDate(new Date());
            update.setRemark(StrUtil.trimToNull(valve.getCurrentBinCode()));
        }
        if (Objects.equals(status, 3) && valve.getOutboundTime() == null) {
            update.setOutboundTime(new Date());
        }
        if (Objects.equals(status, 3)) {
            update.setRemark(appendBinRemark(valve.getRemark(), valve.getCurrentBinCode()));
            update.setCurrentBinId(null);
            update.setCurrentBinCode(null);
        }
        valveMapper.updateById(update);
        if (Objects.equals(status, 3)) {
            valveMapper.update(null, Wrappers.<Valve>lambdaUpdate()
                .eq(Valve::getId, valve.getId())
                .set(Valve::getCurrentBinId, null)
                .set(Valve::getCurrentBinCode, null));
        }
    }

    private String appendBinRemark(String remark, String binCode) {
        String normalizedBinCode = StrUtil.trimToNull(binCode);
        if (normalizedBinCode == null) {
            return StrUtil.trimToNull(remark);
        }
        String normalizedRemark = StrUtil.trimToNull(remark);
        if (normalizedRemark == null) {
            return normalizedBinCode;
        }
        for (String part : normalizedRemark.split("[,，]")) {
            if (StrUtil.equals(StrUtil.trimToNull(part), normalizedBinCode)) {
                return normalizedRemark;
            }
        }
        return normalizedRemark + "，" + normalizedBinCode;
    }

    private void clearValveCurrentBinAfterInspectionEmptyReturn(String taskNo, String binCode) {
        AgvTask task = agvTaskMapper.selectOne(Wrappers.lambdaQuery(AgvTask.class).eq(AgvTask::getTaskNo, taskNo));
        String valveNo = task == null ? null : StrUtil.trimToNull(task.getBizOrderNo());
        String palletNo = task == null ? null : StrUtil.trimToNull(task.getPalletCode());
        Valve valve = findValveForWorkflow(valveNo, palletNo);
        if (valve == null) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getCurrentBinCode, binCode);
            wrapper.orderByDesc(Valve::getUpdateTime);
            wrapper.last("limit 1");
            valve = valveMapper.selectOne(wrapper);
        }
        if (valve == null) {
            return;
        }
        valveMapper.update(null, Wrappers.<Valve>lambdaUpdate()
            .eq(Valve::getId, valve.getId())
            .set(Valve::getCurrentBinId, null)
            .set(Valve::getCurrentBinCode, null));
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
                        updateValveStatus(task.getBizOrderNo(), task.getPalletCode(), 0);
                    }
                    return;
                }
                binService.markEmptyBin(route.firstStep.fromBinCode);
                if (!dispatchInspectionStep(taskNo, 2, route.secondStep, route.targetBinCode, matCode)) {
                    return;
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
                // 送检完成后样品仍处于检测中，回库完成后才更新为已检测。
                AgvTask task = agvTaskMapper.selectOne(Wrappers.lambdaQuery(AgvTask.class).eq(AgvTask::getTaskNo, taskNo));
                if (task != null && task.getPalletCode() != null) {
                    updateValveStatus(task.getBizOrderNo(), task.getPalletCode(), 1);
                }
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            } finally {
                triggerInboundQueueDispatch();
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

    private void dispatchOutboundFollowupSteps(String taskNo, OutboundRoute route, String matCode,
                                               String valveNo, String palletNo) {
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
                updateValveStatus(valveNo, palletNo, 3);
                binService.markEmptyBin(route.firstStep.fromBinCode);
                unbindPalletSilently(palletNo);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            } finally {
                triggerInboundQueueDispatch();
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
            wrapper.eq(Valve::getCurrentBinCode, palletNo);
            wrapper.orderByDesc(Valve::getUpdateTime);
            wrapper.last("limit 1");
            valve = valveMapper.selectOne(wrapper);
        }
        if (valve != null) {
            target = StrUtil.trimToNull(valve.getInspectionTargetBin());
        }
        if (target == null && StrUtil.isNotBlank(palletNo)) {
            String palletType = resolvePalletTypeCodeFromBinCode(palletNo);
            target = resolveInspectionTargetBin(INSPECTION_AREA_WAITING, palletType);
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
                binService.markEmptyPallet(route.targetBinCode);
                clearValveCurrentBinAfterInspectionEmptyReturn(taskNo, route.targetBinCode);
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
                binService.markEmptyBin(route.firstStep.fromBinCode);
                if (!dispatchReturnCallPalletStep(taskNo, 2, route.secondStep, route.targetBinCode)) {
                    return;
                }
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            }
        }, inboundExecutor);
    }

    private void dispatchValveReturnFollowupSteps(String taskNo, InboundRoute route, String palletTypeCode,
                                                  String matCode, String valveNo, String palletNo) {
        CompletableFuture.runAsync(() -> {
            try {
                String previousBinCode = resolveCurrentValveBinCode(valveNo, palletNo);
                if (!waitForOpenTaskFinished(buildInboundStepOutId(taskNo, 1))) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "样品回库步骤1未完成");
                    return;
                }
                PalletVo outboundPallet = resolveNextOutsideReplenishmentPallet(route.firstStep.fromBinCode,
                    palletTypeCode, route.targetBinCode, route.secondStep.fromBinCode);
                if (outboundPallet == null || StrUtil.isBlank(outboundPallet.getCurrentBinCode())) {
                    agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, "未找到可补位空托盘");
                    return;
                }
                InboundStep thirdStep = new InboundStep(route.thirdStep.agvRange,
                    outboundPallet.getCurrentBinCode(), route.thirdStep.toBinCode);
                if (!dispatchInboundReplenishmentStep(taskNo, 2, route.secondStep, thirdStep,
                    route.targetBinCode, matCode)) {
                    return;
                }
                moveInboundPalletInside(palletNo, route.targetBinCode);
                binService.markFullPallet(route.targetBinCode,
                    resolveValveNoForStorage(valveNo, palletNo, route.targetBinCode));
                binService.markEmptyBin(thirdStep.fromBinCode);
                if (StrUtil.isNotBlank(previousBinCode)
                    && !StrUtil.equals(previousBinCode, route.targetBinCode)) {
                    binService.markEmptyBin(previousBinCode);
                }
                if (!dispatchInboundStep(taskNo, 4, route.fourthStep, route.targetBinCode, null)) {
                    return;
                }
                moveOutboundPalletOutside(outboundPallet, route.firstStep.fromBinCode, route.firstStep.fromBinCode);
                updateValveStorage(valveNo, palletNo, route.targetBinCode, 2);
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 2, null);
            } catch (Exception e) {
                agvTaskService.updateTaskStatusByTaskNo(taskNo, 3, e.getMessage());
            } finally {
                triggerInboundQueueDispatch();
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
                binService.markEmptyPallet(route.targetBinCode);
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

    private AgvOpenTaskBo buildContinuousPickDropTask(String outId,
                                                      String firstFromBinCode, String firstToBinCode, String firstMatCode,
                                                      String secondFromBinCode, String secondToBinCode, String secondMatCode,
                                                      String agvRange) {
        AgvOpenTaskBo taskBo = new AgvOpenTaskBo();
        taskBo.setTaskType(AGV_TASK_TYPE_PICK_AND_DROP);
        taskBo.setOutId(outId);
        taskBo.setLevel(AGV_TASK_LEVEL_NORMAL);
        taskBo.setAgvRange(agvRange);

        List<AgvOpenTaskBo.AgvTaskPoint> points = new ArrayList<>();
        points.add(buildTaskPoint("01", firstFromBinCode, "02", null));
        points.add(buildTaskPoint("02", firstToBinCode, "04", firstMatCode));
        points.add(buildTaskPoint("03", secondFromBinCode, "02", null));
        points.add(buildTaskPoint("04", secondToBinCode, "04", secondMatCode));
        taskBo.setPoints(points);
        return taskBo;
    }

    private AgvOpenTaskBo.AgvTaskPoint buildTaskPoint(String sn, String pointCode, String pointType, String matCode) {
        AgvOpenTaskBo.AgvTaskPoint point = new AgvOpenTaskBo.AgvTaskPoint();
        point.setSn(sn);
        point.setPointCode(pointCode);
        point.setPointType(pointType);
        if (StrUtil.isNotBlank(matCode)) {
            point.setMatCode(matCode);
        }
        return point;
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

    private void updateValveStorage(String valveNo, String palletNo, String targetBinCode, Integer status) {
        Valve valve = findValve(valveNo, palletNo);
        if (valve == null) {
            return;
        }
        Valve update = new Valve();
        update.setId(valve.getId());
        BinVo binVo = binService.queryByBinCode(targetBinCode);
        if (binVo != null) {
            update.setCurrentBinId(binVo.getId());
        }
        update.setCurrentBinCode(StrUtil.trimToNull(targetBinCode));
        update.setStatus(status);
        if (Objects.equals(status, 2)) {
            update.setReturnDate(new Date());
        }
        valveMapper.updateById(update);
    }

    private String resolveCurrentValveBinCode(String valveNo, String palletNo) {
        Valve valve = findValve(valveNo, palletNo);
        return valve == null ? null : StrUtil.trimToNull(valve.getCurrentBinCode());
    }

    private Valve findValve(String valveNo, String palletNo) {
        if (StrUtil.isNotBlank(valveNo)) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getValveNo, valveNo);
            Valve valve = valveMapper.selectOne(wrapper);
            if (valve != null) {
                return valve;
            }
        }
        if (StrUtil.isNotBlank(palletNo)) {
            LambdaQueryWrapper<Valve> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Valve::getCurrentBinCode, palletNo);
            wrapper.orderByDesc(Valve::getUpdateTime);
            wrapper.last("limit 1");
            return valveMapper.selectOne(wrapper);
        }
        return null;
    }

    private String selectFirstAvailableBinCode(Object dataObj, PdaBinAvailableRequest request) {
        String palletTypeCode = resolveAvailableBinPalletType(request);
        if (dataObj instanceof List<?> list) {
            String selectedBin = list.stream()
                .filter(item -> item instanceof Map)
                .map(item -> (Map<?, ?>) item)
                .filter(item -> isAgvBinFreeState(MapUtil.getStr(item, "binState")))
                .map(item -> MapUtil.getStr(item, "binCode"))
                .filter(StrUtil::isNotBlank)
                .filter(binCode -> isBinOnRequestedLevel(binCode, request.getStorageLevel()))
                .filter(binCode -> isBinOnRequestedFloor(binCode, request.getFirstFloor()))
                .filter(binCode -> isWmsAvailableInboundBin(binCode, palletTypeCode))
                .filter(binCode -> !hasActiveInboundTaskAtTargetBin(binCode))
                .sorted(inboundBinComparator(palletTypeCode))
                .findFirst()
                .orElse(null);
            return StrUtil.isNotBlank(selectedBin) ? selectedBin : selectFirstWmsAvailableInboundBinCode(request, palletTypeCode);
        }
        if (dataObj instanceof Map<?, ?> map) {
            String binState = MapUtil.getStr(map, "binState");
            String binCode = MapUtil.getStr(map, "binCode");
            if (isAgvBinFreeState(binState)
                && StrUtil.isNotBlank(binCode)
                && isBinOnRequestedLevel(binCode, request.getStorageLevel())
                && isBinOnRequestedFloor(binCode, request.getFirstFloor())
                && isWmsAvailableInboundBin(binCode, palletTypeCode)
                && !hasActiveInboundTaskAtTargetBin(binCode)) {
                return binCode;
            }
        }
        return selectFirstWmsAvailableInboundBinCode(request, palletTypeCode);
    }

    private String buildNoAvailableBinMessage(PdaBinAvailableRequest request) {
        String floor = "";
        if (request.getStorageLevel() != null) {
            floor = formatStorageLevel(request.getStorageLevel());
        } else if (request.getFirstFloor() != null) {
            floor = request.getFirstFloor() ? "一层" : "二/三层";
        }
        return "没有" + floor + "可用库位";
    }

    private String resolveAvailableBinPalletType(PdaBinAvailableRequest request) {
        String type = StrUtil.trimToNull(request.getPalletType());
        if (type != null) {
            if (isSmallPalletType(type)) {
                return PALLET_TYPE_SMALL_CODE;
            }
            if (isLargePalletType(type)) {
                return PALLET_TYPE_LARGE_CODE;
            }
        }
        String outsideSite = StrUtil.trimToNull(request.getOutsideSite());
        if (outsideSite == null) {
            return null;
        }
        return INBOUND_LARGE_LOAD_BIN.equals(outsideSite) ? PALLET_TYPE_LARGE_CODE : PALLET_TYPE_SMALL_CODE;
    }

    private boolean isBinOnRequestedFloor(String binCode, Boolean firstFloor) {
        if (firstFloor == null) {
            return true;
        }
        Integer level = extractBinLevel(binCode);
        if (level == null) {
            return false;
        }
        return firstFloor ? level == 1 : level > 1;
    }

    private boolean isBinOnRequestedLevel(String binCode, Integer storageLevel) {
        if (storageLevel == null) {
            return true;
        }
        Integer level = extractBinLevel(binCode);
        return level != null && Objects.equals(level, storageLevel);
    }

    private String formatStorageLevel(Integer storageLevel) {
        if (storageLevel == null) {
            return "";
        }
        if (storageLevel == 1) {
            return "一层";
        }
        if (storageLevel == 2) {
            return "二层";
        }
        if (storageLevel == 3) {
            return "三层";
        }
        return storageLevel + "层";
    }

    private boolean isWmsAvailableInboundBin(String binCode, String palletTypeCode) {
        BinVo bin = binService.queryByBinCode(binCode);
        return bin != null
            && isWmsBinTypeAllowedForPalletType(bin.getBinType(), palletTypeCode)
            && Objects.equals(bin.getStorageStatus(), BinService.STORAGE_STATUS_EMPTY_BIN)
            && Objects.equals(bin.getStatus(), 0)
            && StrUtil.isBlank(bin.getBoundFactoryNo());
    }

    private String selectFirstWmsAvailableInboundBinCode(PdaBinAvailableRequest request, String palletTypeCode) {
        return binService.queryAvailableBins(request.getWarehouseId(), request.getAreaId()).stream()
            .filter(bin -> bin != null && StrUtil.isNotBlank(bin.getBinCode()))
            .filter(bin -> isWmsBinTypeAllowedForPalletType(bin.getBinType(), palletTypeCode))
            .filter(bin -> StrUtil.isBlank(bin.getBoundFactoryNo()))
            .map(BinVo::getBinCode)
            .filter(binCode -> isBinOnRequestedLevel(binCode, request.getStorageLevel()))
            .filter(binCode -> isBinOnRequestedFloor(binCode, request.getFirstFloor()))
            .filter(binCode -> !hasActiveInboundTaskAtTargetBin(binCode))
            .sorted(inboundBinComparator(palletTypeCode))
            .findFirst()
            .orElse(null);
    }

    private boolean isAgvBinFreeState(String binState) {
        String normalized = StrUtil.trimToEmpty(binState);
        return StrUtil.isBlank(normalized)
            || "01".equals(normalized)
            || "00".equals(normalized)
            || "0".equals(normalized)
            || "FREE".equalsIgnoreCase(normalized)
            || "IDLE".equalsIgnoreCase(normalized)
            || "EMPTY".equalsIgnoreCase(normalized)
            || "空闲".equals(normalized)
            || "空库位".equals(normalized);
    }

    private boolean isWmsBinTypeAllowedForPalletType(Integer binType, String palletTypeCode) {
        if (StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_SMALL_CODE)) {
            return Objects.equals(binType, BIN_TYPE_SMALL_PALLET);
        }
        if (StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_LARGE_CODE)) {
            return Objects.equals(binType, BIN_TYPE_LARGE_PALLET);
        }
        return true;
    }

    private Comparator<String> inboundBinComparator(String palletTypeCode) {
        List<String> preferredBins = StrUtil.equalsIgnoreCase(palletTypeCode, PALLET_TYPE_LARGE_CODE)
            ? INBOUND_LARGE_PREFERRED_STORAGE_BINS : INBOUND_SMALL_PREFERRED_STORAGE_BINS;
        return Comparator
            .comparingInt((String binCode) -> inboundPreferredBinIndex(binCode, preferredBins))
            .thenComparingInt(binCode -> Optional.ofNullable(extractBinBay(binCode)).orElse(Integer.MAX_VALUE))
            .thenComparing(binCode -> binCode);
    }

    private int inboundPreferredBinIndex(String binCode, List<String> preferredBins) {
        int index = preferredBins.indexOf(binCode);
        return index >= 0 ? index : Integer.MAX_VALUE;
    }

    private Integer extractBinBay(String binCode) {
        if (StrUtil.isBlank(binCode)) {
            return null;
        }
        String[] parts = binCode.trim().split("-");
        if (parts.length < 3) {
            return null;
        }
        try {
            return Integer.parseInt(parts[1]);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer extractBinLevel(String binCode) {
        if (StrUtil.isBlank(binCode)) {
            return null;
        }
        String[] parts = binCode.trim().split("-");
        if (parts.length < 3) {
            return null;
        }
        try {
            return Integer.parseInt(parts[parts.length - 1]);
        } catch (NumberFormatException e) {
            return null;
        }
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

    private static class PreparedInboundTask {
        private final AgvTask task;
        private final String taskNo;
        private final String palletNo;
        private final InboundRoute route;
        private final String palletTypeCode;
        private final String matCode;

        private PreparedInboundTask(AgvTask task, String taskNo, String palletNo,
                                    InboundRoute route, String palletTypeCode, String matCode) {
            this.task = task;
            this.taskNo = taskNo;
            this.palletNo = palletNo;
            this.route = route;
            this.palletTypeCode = palletTypeCode;
            this.matCode = matCode;
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
