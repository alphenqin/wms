# PDA数据处理流程文档

> **文档说明**：本文档详细说明PDA发送过来的数据在WMS系统中的处理流程，包括数据接收、校验、转换、存储等各个环节。

---

## 目录

1. [概述](#1-概述)
2. [登录接口数据处理](#2-登录接口数据处理)
3. [托盘扫码接口数据处理](#3-托盘扫码接口数据处理)
4. [阀门绑定接口数据处理](#4-阀门绑定接口数据处理)
5. [阀门查询接口数据处理](#5-阀门查询接口数据处理)
6. [任务查询接口数据处理](#6-任务查询接口数据处理)
7. [数据转换规则](#7-数据转换规则)
8. [异常处理机制](#8-异常处理机制)

---

## 1. 概述

### 1.1 数据处理流程

PDA发送的数据在WMS系统中的处理流程如下：

```
PDA请求 → 参数校验 → 业务逻辑处理 → 数据转换 → 数据库操作 → 响应返回
```

### 1.2 涉及的主要组件

- **控制器层**：`PdaApiController` - 接收PDA请求
- **服务层**：各种Service类 - 处理业务逻辑
- **数据访问层**：Mapper接口 - 数据库操作
- **实体层**：Entity类 - 数据库表映射
- **DTO层**：DTO类 - 数据传输对象

---

## 2. 登录接口数据处理

### 2.1 接口信息

- **接口地址**：`POST /api/auth/login`
- **请求DTO**：`PdaLoginRequest`
- **响应DTO**：`PdaLoginResponse`

### 2.2 接收的数据

```json
{
  "username": "pda001",      // 用户名
  "password": "123456",      // 密码
  "deviceCode": "PDA-01"     // 设备编码（当前未使用）
}
```

### 2.3 处理流程

#### 步骤1：参数校验
- **位置**：`@Valid @RequestBody PdaLoginRequest request`
- **校验规则**：
  - `username`：使用`@NotBlank`注解校验，不能为空
  - `password`：使用`@NotBlank`注解校验，不能为空
  - `deviceCode`：使用`@NotBlank`注解校验，不能为空

#### 步骤2：用户认证
- **调用服务**：`SysLoginService.login()`
- **处理逻辑**：
  ```java
  String token = loginService.login(
      request.getUsername(),    // 用户名
      request.getPassword(),     // 密码
      "",                       // 验证码（PDA登录不验证）
      ""                        // UUID（PDA登录不验证）
  );
  ```
- **内部处理**：
  1. 根据用户名查询用户信息（`SysUserVo`）
  2. 使用BCrypt验证密码
  3. 构建`LoginUser`对象
  4. 调用`LoginHelper.loginByDevice()`生成Token
  5. 返回Token字符串

#### 步骤3：获取用户信息
- **调用服务**：`SysUserService.selectUserById()`
- **处理逻辑**：
  ```java
  LoginUser loginUser = LoginHelper.getLoginUser(token);
  SysUserVo user = userService.selectUserById(loginUser.getUserId());
  ```
- **获取数据**：
  - 用户ID
  - 用户姓名（`nickName`或`userName`）
  - 用户角色权限列表

#### 步骤4：计算Token过期时间
- **处理逻辑**：
  ```java
  LocalDateTime expireTime = LocalDateTime.now().plusSeconds(tokenTimeout);
  // tokenTimeout从配置文件读取，默认86400秒（24小时）
  ```
- **格式转换**：
  ```java
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  String expireAt = sdf.format(Date.from(expireTime.atZone(ZoneId.systemDefault()).toInstant()));
  ```

#### 步骤5：构建响应数据
- **处理逻辑**：
  ```java
  PdaLoginResponse response = new PdaLoginResponse();
  response.setToken(token);                                    // Token值
  response.setExpireAt(expireAt);                              // 过期时间
  response.setUserName(user.getNickName() != null ? 
      user.getNickName() : user.getUserName());                // 用户姓名
  response.setRoles(roles);                                    // 角色列表
  ```
- **角色处理**：
  - 从`LoginUser.getRolePermission()`获取角色权限集合
  - 如果角色为空，默认添加`"PDA_USER"`角色

#### 步骤6：返回响应
- **成功响应**：
  ```json
  {
    "code": 200,
    "msg": "操作成功",
    "data": {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expireAt": "2025-01-15 23:59:59",
      "userName": "张三",
      "roles": ["PDA_USER"]
    }
  }
  ```
- **失败响应**：
  ```json
  {
    "code": 400,
    "msg": "用户名或密码错误",
    "data": null
  }
  ```

### 2.4 数据存储

- **Token存储**：Sa-Token默认存储（内存），不使用Redis
- **用户会话**：存储在Sa-Token的Session中
- **登录日志**：由`SysLoginService`记录到系统日志表

---

## 3. 托盘扫码接口数据处理

### 3.1 接口信息

- **接口地址**：`POST /api/pallet/scan`
- **请求DTO**：`PdaPalletScanRequest`
- **响应DTO**：`PdaPalletScanResponse`

### 3.2 接收的数据

```json
{
  "barcode": "PALLET-QR-CODE-11-01"  // 托盘条码/二维码
}
```

### 3.3 处理流程

#### 步骤1：参数校验
- **位置**：`@Valid @RequestBody PdaPalletScanRequest request`
- **校验规则**：
  - `barcode`：使用`@NotBlank`注解校验，不能为空

#### 步骤2：查询条码信息
- **调用服务**：`BarcodeService.queryByBarcode()`
- **处理逻辑**：
  ```java
  var barcodeVo = barcodeService.queryByBarcode(request.getBarcode());
  ```
- **数据库查询**：
  ```sql
  SELECT * FROM wms_barcode WHERE barcode = 'PALLET-QR-CODE-11-01'
  ```
- **返回数据**：
  - `objectCode`：关联对象编号（托盘编号）
  - `objectType`：关联对象类型（"pallet"）
  - `objectId`：关联对象ID

#### 步骤3：校验条码是否存在
- **处理逻辑**：
  ```java
  if (barcodeVo == null) {
      return R.fail(404, "托盘不存在");
  }
  ```

#### 步骤4：查询托盘信息
- **调用服务**：`PalletService.queryByPalletCode()`
- **处理逻辑**：
  ```java
  PalletVo palletVo = palletService.queryByPalletCode(barcodeVo.getObjectCode());
  ```
- **数据库查询**：
  ```sql
  SELECT * FROM wms_pallet WHERE pallet_code = '11-01'
  ```
- **返回数据**：
  - `palletCode`：托盘编号
  - `palletTypeId`：托盘类型ID
  - `currentBinCode`：当前库位编号
  - 其他托盘属性

#### 步骤5：查询托盘类型
- **调用服务**：`PalletTypeService.getById()`
- **处理逻辑**：
  ```java
  PalletType palletType = palletTypeService.getById(palletVo.getPalletTypeId());
  ```
- **数据库查询**：
  ```sql
  SELECT * FROM wms_pallet_type WHERE id = ?
  ```
- **返回数据**：
  - `typeCode`：托盘类型编号（如"SMALL"、"LARGE"）

#### 步骤6：转换托盘类型
- **处理逻辑**：
  ```java
  String palletTypeCode = "SMALL"; // 默认小托盘
  if (palletType != null && palletType.getTypeCode() != null) {
      String typeCode = palletType.getTypeCode().toUpperCase();
      if (typeCode.contains("LARGE") || typeCode.contains("大")) {
          palletTypeCode = "LARGE";
      } else if (typeCode.contains("SMALL") || typeCode.contains("小")) {
          palletTypeCode = "SMALL";
      }
  }
  ```
- **转换规则**：
  - 如果类型编号包含"LARGE"或"大"，返回"LARGE"
  - 如果类型编号包含"SMALL"或"小"，返回"SMALL"
  - 否则默认返回"SMALL"

#### 步骤7：获取库前置换区站点编码
- **处理逻辑**：
  ```java
  response.setSwapStation(defaultSwapStation);
  // defaultSwapStation从配置文件读取，默认值：WAREHOUSE_SWAP_1
  ```
- **配置来源**：`application.yml`中的`wms.swap-station.default`配置项

#### 步骤8：构建响应数据
- **处理逻辑**：
  ```java
  PdaPalletScanResponse response = new PdaPalletScanResponse();
  response.setPalletNo(palletVo.getPalletCode());           // 托盘编号
  response.setPalletType(palletTypeCode);                   // 托盘类型（SMALL/LARGE）
  response.setSwapStation(defaultSwapStation);              // 置换区站点编码
  response.setBinCode(palletVo.getCurrentBinCode());        // 库位号
  ```

#### 步骤9：返回响应
- **成功响应**：
  ```json
  {
    "code": 200,
    "msg": "操作成功",
    "data": {
      "palletNo": "11-01",
      "palletType": "SMALL",
      "swapStation": "WAREHOUSE_SWAP_1",
      "binCode": "2-01"
    }
  }
  ```

### 3.4 数据存储

- **不涉及数据写入**：此接口只查询数据，不修改数据库
- **查询涉及的表**：
  - `wms_barcode`：条码表
  - `wms_pallet`：托盘表
  - `wms_pallet_type`：托盘类型表

---

## 4. 阀门绑定接口数据处理

### 4.1 接口信息

- **接口地址**：`POST /api/valve/bind`
- **请求DTO**：`PdaValveBindRequest`
- **响应DTO**：`Map<String, Object>`

### 4.2 接收的数据

```json
{
  "valveNo": "V20250101-001",        // 阀门编号
  "matCode": "MAT-DN50-001",         // 物料编码
  "valveModel": "DN50",              // 阀门型号
  "vendorName": "XX阀门厂",          // 厂家名称
  "inboundDate": "2025-01-15",       // 入库日期
  "palletNo": "11-01",               // 托盘号
  "binCode": "2-01"                  // 库位号
}
```

### 4.3 处理流程

#### 步骤1：参数校验
- **位置**：`@Valid @RequestBody PdaValveBindRequest request`
- **校验规则**：所有字段都使用`@NotBlank`注解校验，不能为空

#### 步骤2：校验阀门编号是否已存在
- **调用服务**：`ValveService.queryByValveNo()`
- **处理逻辑**：
  ```java
  ValveVo existingValve = valveService.queryByValveNo(request.getValveNo());
  if (existingValve != null) {
      return R.fail(400, "阀门编号已存在");
  }
  ```
- **数据库查询**：
  ```sql
  SELECT * FROM wms_valve WHERE valve_no = 'V20250101-001'
  ```

#### 步骤3：校验托盘是否存在
- **调用服务**：`PalletService.queryByPalletCode()`
- **处理逻辑**：
  ```java
  PalletVo palletVo = palletService.queryByPalletCode(request.getPalletNo());
  if (palletVo == null) {
      return R.fail(400, "托盘不存在");
  }
  ```
- **数据库查询**：
  ```sql
  SELECT * FROM wms_pallet WHERE pallet_code = '11-01'
  ```

#### 步骤4：校验库位号是否匹配
- **处理逻辑**：
  ```java
  if (!request.getBinCode().equals(palletVo.getCurrentBinCode())) {
      return R.fail(400, "托盘号和库位号不匹配");
  }
  ```
- **业务规则**：确保托盘当前所在的库位与请求中的库位号一致

#### 步骤5：查询库位信息
- **调用服务**：`BinService.queryByBinCode()`
- **处理逻辑**：
  ```java
  var binVo = binService.queryByBinCode(request.getBinCode());
  if (binVo == null) {
      return R.fail(400, "库位不存在");
  }
  ```
- **数据库查询**：
  ```sql
  SELECT * FROM wms_bin WHERE bin_code = '2-01'
  ```

#### 步骤6：创建阀门实体
- **处理逻辑**：
  ```java
  Valve valve = new Valve();
  valve.setValveNo(request.getValveNo());                    // 阀门编号
  valve.setModel(request.getValveModel());                   // 阀门型号
  valve.setManufacturer(request.getVendorName());            // 厂家名称
  valve.setPalletId(palletVo.getId());                       // 托盘ID
  valve.setPalletCode(request.getPalletNo());                // 托盘编号
  valve.setCurrentBinId(binVo.getId());                      // 库位ID
  valve.setCurrentBinCode(request.getBinCode());              // 库位编号
  valve.setStatus(0);                                        // 状态：0=在库（IN_STOCK）
  ```
- **日期解析**：
  ```java
  try {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      valve.setProductionDate(sdf.parse(request.getInboundDate()));
  } catch (Exception e) {
      log.warn("入库日期解析失败: {}", request.getInboundDate());
  }
  ```

#### 步骤7：保存阀门数据
- **调用服务**：`ValveService.insertByBo()`
- **处理逻辑**：
  ```java
  valveService.insertByBo(MapstructUtils.convert(valve, ValveBo.class));
  ```
- **数据库操作**：
  ```sql
  INSERT INTO wms_valve (
      valve_no, model, manufacturer, pallet_id, pallet_code,
      current_bin_id, current_bin_code, status, production_date,
      create_time, create_by
  ) VALUES (
      'V20250101-001', 'DN50', 'XX阀门厂', ?, '11-01',
      ?, '2-01', 0, '2025-01-15',
      NOW(), ?
  )
  ```
- **内部处理**：
  1. 校验阀门编号唯一性
  2. 设置默认状态为0（在库）
  3. 设置创建时间和创建人

#### 步骤8：更新托盘绑定状态
- **调用服务**：`PalletService.bindMaterial()`
- **处理逻辑**：
  ```java
  palletService.bindMaterial(palletVo.getId());
  ```
- **数据库操作**：
  ```sql
  UPDATE wms_pallet 
  SET is_bound = 1, is_empty = 0 
  WHERE id = ?
  ```
- **业务规则**：
  - `is_bound = 1`：标记托盘已绑定物料
  - `is_empty = 0`：标记托盘非空

#### 步骤9：构建响应数据
- **处理逻辑**：
  ```java
  Map<String, Object> result = new HashMap<>();
  result.put("success", true);
  return R.ok(result);
  ```

#### 步骤10：返回响应
- **成功响应**：
  ```json
  {
    "code": 200,
    "msg": "操作成功",
    "data": {
      "success": true
    }
  }
  ```

### 4.4 数据存储

- **写入的表**：
  - `wms_valve`：插入新阀门记录
  - `wms_pallet`：更新托盘绑定状态
- **事务管理**：使用`@Transactional`注解，确保数据一致性
- **字段映射关系**：

| PDA请求字段 | 数据库字段 | 说明 |
|------------|-----------|------|
| valveNo | valve_no | 阀门编号 |
| valveModel | model | 阀门型号 |
| vendorName | manufacturer | 厂家名称 |
| inboundDate | production_date | 入库日期（生产日期） |
| palletNo | pallet_code | 托盘编号 |
| binCode | current_bin_code | 库位编号 |
| - | status | 固定为0（在库） |
| - | pallet_id | 从托盘表查询得到 |
| - | current_bin_id | 从库位表查询得到 |

---

## 5. 阀门查询接口数据处理

### 5.1 接口信息

- **接口地址**：`POST /api/valve/query`
- **请求DTO**：`PdaValveQueryRequest`
- **响应DTO**：`PdaValveQueryResponse`

### 5.2 接收的数据

```json
{
  "vendorName": "XX阀门厂",      // 厂家名称（模糊查询，可选）
  "valveNo": "V20250101-001",    // 阀门编号（精确查询，可选）
  "valveModel": "DN50",          // 阀门型号（模糊查询，可选）
  "inboundDate": "2025-01-15",   // 入库日期（可选）
  "valveStatus": "IN_STOCK",     // 阀门状态（可选）
  "pageNum": 1,                  // 页码（默认1）
  "pageSize": 20                 // 每页大小（默认20）
}
```

### 5.3 处理流程

#### 步骤1：参数校验
- **位置**：`@Valid @RequestBody PdaValveQueryRequest request`
- **校验规则**：所有字段都是可选的，不需要必填校验

#### 步骤2：构建查询条件
- **使用框架**：MyBatis-Plus的`LambdaQueryWrapper`
- **处理逻辑**：
  ```java
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
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      Date inboundDate = sdf.parse(request.getInboundDate());
      wrapper.eq(Valve::getProductionDate, inboundDate);
  }
  
  // 阀门状态（需要转换枚举值）
  if (StrUtil.isNotBlank(request.getValveStatus())) {
      Integer status = convertValveStatus(request.getValveStatus());
      if (status != null) {
          wrapper.eq(Valve::getStatus, status);
      }
  }
  ```

#### 步骤3：状态枚举转换
- **处理逻辑**：
  ```java
  private Integer convertValveStatus(String valveStatus) {
      switch (valveStatus.toUpperCase()) {
          case "IN_STOCK":        return 0;  // 在库
          case "IN_INSPECTION":   return 1;  // 检测中
          case "INSPECTED":       return 2;  // 已检测
          case "OUTBOUND":        return 3;  // 已出库
          default:                return null;
      }
  }
  ```

#### 步骤4：分页查询
- **处理逻辑**：
  ```java
  Page<Valve> page = new Page<>(request.getPageNum(), request.getPageSize());
  Page<Valve> result = valveMapper.selectPage(page, wrapper);
  ```
- **数据库查询**：
  ```sql
  SELECT * FROM wms_valve 
  WHERE manufacturer LIKE '%XX阀门厂%'
    AND valve_no = 'V20250101-001'
    AND model LIKE '%DN50%'
    AND production_date = '2025-01-15'
    AND status = 0
  LIMIT 20 OFFSET 0
  ```

#### 步骤5：数据转换
- **处理逻辑**：
  ```java
  List<PdaValveInfo> list = result.getRecords().stream().map(valve -> {
      PdaValveInfo info = new PdaValveInfo();
      info.setValveNo(valve.getValveNo());                    // 阀门编号
      info.setValveModel(valve.getModel());                    // 阀门型号
      info.setVendorName(valve.getManufacturer());             // 厂家名称
      info.setPalletNo(valve.getPalletCode());                 // 托盘编号
      info.setBinCode(valve.getCurrentBinCode());              // 库位编号
      info.setValveStatus(convertValveStatusToString(valve.getStatus()));  // 状态枚举
      
      // 入库日期格式化
      if (valve.getProductionDate() != null) {
          SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
          info.setInboundDate(sdf.format(valve.getProductionDate()));
      }
      
      // 物料编码（临时生成，后续可从物料类型表获取）
      info.setMatCode("MAT-" + valve.getValveNo());
      
      return info;
  }).collect(Collectors.toList());
  ```

#### 步骤6：状态枚举反向转换
- **处理逻辑**：
  ```java
  private String convertValveStatusToString(Integer status) {
      switch (status) {
          case 0: return "IN_STOCK";
          case 1: return "IN_INSPECTION";
          case 2: return "INSPECTED";
          case 3: return "OUTBOUND";
          default: return null;
      }
  }
  ```

#### 步骤7：构建响应数据
- **处理逻辑**：
  ```java
  PdaValveQueryResponse response = new PdaValveQueryResponse();
  response.setList(list);                                      // 数据列表
  response.setTotal(result.getTotal());                        // 总记录数
  response.setPageNum(request.getPageNum());                    // 当前页码
  response.setPageSize(request.getPageSize());                  // 每页大小
  ```

#### 步骤8：返回响应
- **成功响应**：
  ```json
  {
    "code": 200,
    "msg": "操作成功",
    "data": {
      "list": [
        {
          "valveNo": "V20250101-001",
          "matCode": "MAT-V20250101-001",
          "valveModel": "DN50",
          "vendorName": "XX阀门厂",
          "inboundDate": "2025-01-15",
          "palletNo": "11-01",
          "binCode": "2-01",
          "valveStatus": "IN_STOCK"
        }
      ],
      "total": 1,
      "pageNum": 1,
      "pageSize": 20
    }
  }
  ```

### 5.4 数据存储

- **不涉及数据写入**：此接口只查询数据，不修改数据库
- **查询涉及的表**：
  - `wms_valve`：阀门表

---

## 6. 任务查询接口数据处理

### 6.1 接口信息

- **接口地址**：`POST /api/task/query`
- **请求DTO**：`PdaTaskQueryRequest`
- **响应DTO**：`PdaTaskQueryResponse`

### 6.2 接收的数据

```json
{
  "startDate": "2025-01-15",           // 起始日期（可选）
  "endDate": "2025-01-15",             // 结束日期（可选）
  "taskType": "INBOUND",               // 任务类型（可选）
  "status": "PENDING",                // 任务状态（可选）
  "pageNum": 1,                       // 页码（默认1）
  "pageSize": 20                      // 每页大小（默认20）
}
```

### 6.3 处理流程

#### 步骤1：参数校验
- **位置**：`@Valid @RequestBody PdaTaskQueryRequest request`
- **校验规则**：所有字段都是可选的

#### 步骤2：构建查询条件
- **使用框架**：MyBatis-Plus的`LambdaQueryWrapper`
- **处理逻辑**：
  ```java
  LambdaQueryWrapper<AgvTask> wrapper = Wrappers.lambdaQuery();
  
  // 日期范围处理
  if (StrUtil.isNotBlank(request.getStartDate()) || StrUtil.isNotBlank(request.getEndDate())) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      
      if (StrUtil.isNotBlank(request.getStartDate())) {
          Date startDate = sdf.parse(request.getStartDate());
          wrapper.ge(AgvTask::getCreateTime, startDate);  // >= 起始日期
      }
      
      if (StrUtil.isNotBlank(request.getEndDate())) {
          Date endDate = sdf.parse(request.getEndDate());
          // 结束日期需要包含当天，所以加一天
          Calendar cal = Calendar.getInstance();
          cal.setTime(endDate);
          cal.add(Calendar.DAY_OF_MONTH, 1);
          wrapper.lt(AgvTask::getCreateTime, cal.getTime());  // < 结束日期+1天
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
  ```

#### 步骤3：任务类型枚举转换
- **处理逻辑**：
  ```java
  private Integer convertTaskType(String taskType) {
      switch (taskType.toUpperCase()) {
          case "INBOUND":          return 1;  // 入库任务
          case "SEND_INSPECTION": return 2;  // 送检任务
          case "RETURN":          return 3;  // 回库任务
          case "OUTBOUND":        return 4;  // 出库任务
          default:                return null;
      }
  }
  ```

#### 步骤4：任务状态枚举转换
- **处理逻辑**：
  ```java
  private Integer convertTaskStatus(String status) {
      switch (status.toUpperCase()) {
          case "PENDING":   return 0;  // 待处理
          case "EXECUTING": return 1;  // 执行中
          case "COMPLETED": return 2;  // 已完成
          case "CANCELLED": return 4;  // 已取消
          case "FAILED":   return 3;  // 失败
          default:         return null;
      }
  }
  ```

#### 步骤5：分页查询
- **处理逻辑**：
  ```java
  Page<AgvTask> page = new Page<>(request.getPageNum(), request.getPageSize());
  Page<AgvTask> result = agvTaskMapper.selectPage(page, wrapper);
  ```
- **数据库查询**：
  ```sql
  SELECT * FROM wms_agv_task 
  WHERE create_time >= '2025-01-15 00:00:00'
    AND create_time < '2025-01-16 00:00:00'
    AND task_type = 1
    AND status = 0
  LIMIT 20 OFFSET 0
  ```

#### 步骤6：数据转换
- **处理逻辑**：
  ```java
  List<PdaTaskInfo> list = result.getRecords().stream().map(task -> {
      PdaTaskInfo info = new PdaTaskInfo();
      info.setOutID(task.getTaskNo());                        // 任务编号
      info.setTaskType(convertTaskTypeToString(task.getTaskType()));  // 任务类型枚举
      info.setStatus(convertTaskStatusToString(task.getStatus()));    // 任务状态枚举
      info.setPalletNo(task.getPalletCode());                 // 托盘编号
      
      // 创建时间格式化
      if (task.getCreateTime() != null) {
          SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
          info.setCreateTime(sdf.format(task.getCreateTime()));
      }
      
      // 阀门编号和物料编码（可以从关联的阀门表查询，当前留空）
      // info.setValveNo(...);
      // info.setMatCode(...);
      
      info.setBinCode(task.getToBinCode());                   // 目标库位编号
      
      return info;
  }).collect(Collectors.toList());
  ```

#### 步骤7：任务类型和状态反向转换
- **处理逻辑**：
  ```java
  private String convertTaskTypeToString(Integer taskType) {
      switch (taskType) {
          case 1: return "INBOUND";
          case 2: return "SEND_INSPECTION";
          case 3: return "RETURN";
          case 4: return "OUTBOUND";
          default: return null;
      }
  }
  
  private String convertTaskStatusToString(Integer status) {
      switch (status) {
          case 0: return "PENDING";
          case 1: return "EXECUTING";
          case 2: return "COMPLETED";
          case 3: return "FAILED";
          case 4: return "CANCELLED";
          default: return null;
      }
  }
  ```

#### 步骤8：构建响应数据
- **处理逻辑**：
  ```java
  PdaTaskQueryResponse response = new PdaTaskQueryResponse();
  response.setList(list);                                      // 数据列表
  response.setTotal(result.getTotal());                        // 总记录数
  response.setPageNum(request.getPageNum());                    // 当前页码
  response.setPageSize(request.getPageSize());                  // 每页大小
  ```

#### 步骤9：返回响应
- **成功响应**：
  ```json
  {
    "code": 200,
    "msg": "操作成功",
    "data": {
      "list": [
        {
          "outID": "R20250115145830123",
          "taskType": "INBOUND",
          "status": "PENDING",
          "createTime": "2025-01-15 14:58:30",
          "palletNo": "11-01",
          "binCode": "2-01"
        }
      ],
      "total": 1,
      "pageNum": 1,
      "pageSize": 20
    }
  }
  ```

### 6.4 数据存储

- **不涉及数据写入**：此接口只查询数据，不修改数据库
- **查询涉及的表**：
  - `wms_agv_task`：AGV任务表

---

## 7. 数据转换规则

### 7.1 日期格式转换

#### 输入格式（PDA → WMS）
- **日期**：`yyyy-MM-dd`（如：`2025-01-15`）
- **日期时间**：`yyyy-MM-dd HH:mm:ss`（如：`2025-01-15 14:58:30`）

#### 输出格式（WMS → PDA）
- **日期**：`yyyy-MM-dd`
- **日期时间**：`yyyy-MM-dd HH:mm:ss`

#### 转换方法
```java
// 字符串转Date
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
Date date = sdf.parse("2025-01-15");

// Date转字符串
String dateStr = sdf.format(date);
```

### 7.2 枚举值转换

#### 阀门状态转换

| PDA枚举值 | 数据库值 | 说明 |
|----------|---------|------|
| IN_STOCK | 0 | 在库 |
| IN_INSPECTION | 1 | 检测中 |
| INSPECTED | 2 | 已检测 |
| OUTBOUND | 3 | 已出库 |

#### 任务类型转换

| PDA枚举值 | 数据库值 | 说明 |
|----------|---------|------|
| INBOUND | 1 | 入库任务 |
| SEND_INSPECTION | 2 | 送检任务 |
| RETURN | 3 | 回库任务 |
| OUTBOUND | 4 | 出库任务 |

#### 任务状态转换

| PDA枚举值 | 数据库值 | 说明 |
|----------|---------|------|
| PENDING | 0 | 待处理 |
| EXECUTING | 1 | 执行中 |
| COMPLETED | 2 | 已完成 |
| FAILED | 3 | 失败 |
| CANCELLED | 4 | 已取消 |

### 7.3 托盘类型转换

| 数据库类型编号 | PDA类型 | 判断规则 |
|--------------|---------|---------|
| 包含"LARGE"或"大" | LARGE | 大托盘（33个） |
| 包含"SMALL"或"小" | SMALL | 小托盘（132个） |
| 其他 | SMALL | 默认小托盘 |

### 7.4 物料编码生成

- **当前实现**：`"MAT-" + valveNo`
- **说明**：临时实现，后续可从物料类型表（`wms_material_type`）关联查询

---

## 8. 异常处理机制

### 8.1 参数校验异常

- **触发条件**：请求参数不符合`@Valid`注解的校验规则
- **处理方式**：Spring框架自动返回400错误，包含详细的校验错误信息
- **示例**：
  ```json
  {
    "code": 400,
    "msg": "参数校验失败",
    "data": null
  }
  ```

### 8.2 业务校验异常

- **触发条件**：业务逻辑校验失败（如：阀门编号已存在、托盘不存在等）
- **处理方式**：返回400错误，包含具体的业务错误信息
- **示例**：
  ```json
  {
    "code": 400,
    "msg": "阀门编号已存在",
    "data": null
  }
  ```

### 8.3 数据不存在异常

- **触发条件**：查询的数据不存在
- **处理方式**：返回404错误
- **示例**：
  ```json
  {
    "code": 404,
    "msg": "托盘不存在",
    "data": null
  }
  ```

### 8.4 系统异常

- **触发条件**：代码执行过程中发生未预期的异常
- **处理方式**：
  1. 记录异常日志（使用`log.error()`）
  2. 返回500错误，包含错误信息
- **示例**：
  ```json
  {
    "code": 500,
    "msg": "托盘扫码失败: 数据库连接异常",
    "data": null
  }
  ```

### 8.5 事务回滚

- **触发条件**：在`@Transactional`方法中抛出异常
- **处理方式**：自动回滚当前事务中的所有数据库操作
- **应用场景**：阀门绑定接口（确保阀门和托盘状态的一致性）

### 8.6 异常日志记录

- **位置**：所有catch块中
- **格式**：
  ```java
  log.error("操作描述", exception);
  ```
- **示例**：
  ```java
  log.error("托盘扫码失败", e);
  log.error("阀门绑定失败", e);
  log.error("阀门查询失败", e);
  log.error("任务查询失败", e);
  ```

---

## 9. 数据流程图

### 9.1 登录接口数据流

```
PDA请求
  ↓
参数校验 (@Valid)
  ↓
调用登录服务 (SysLoginService.pdaLogin)
  ↓
查询用户表 (sys_user)
  ↓
验证密码 (BCrypt)
  ↓
生成Token (Sa-Token)
  ↓
Sa-Token默认存储（内存）
  ↓
查询用户信息 (SysUserService)
  ↓
计算过期时间
  ↓
构建响应DTO
  ↓
返回JSON响应
```

### 9.2 托盘扫码接口数据流

```
PDA请求 (barcode)
  ↓
参数校验 (@Valid)
  ↓
查询条码表 (wms_barcode) → 获取objectCode
  ↓
查询托盘表 (wms_pallet) → 使用objectCode
  ↓
查询托盘类型表 (wms_pallet_type) → 使用palletTypeId
  ↓
转换托盘类型 (SMALL/LARGE)
  ↓
获取置换区站点编码 (配置)
  ↓
构建响应DTO
  ↓
返回JSON响应
```

### 9.3 阀门绑定接口数据流

```
PDA请求 (阀门信息)
  ↓
参数校验 (@Valid)
  ↓
校验阀门编号是否存在 (wms_valve)
  ↓
校验托盘是否存在 (wms_pallet)
  ↓
校验库位号是否匹配
  ↓
查询库位信息 (wms_bin)
  ↓
创建阀门实体 (Valve)
  ↓
解析入库日期 (String → Date)
  ↓
开启事务 (@Transactional)
  ↓
插入阀门记录 (wms_valve)
  ↓
更新托盘状态 (wms_pallet: is_bound=1, is_empty=0)
  ↓
提交事务
  ↓
构建响应DTO
  ↓
返回JSON响应
```

### 9.4 阀门查询接口数据流

```
PDA请求 (查询条件)
  ↓
参数校验 (@Valid)
  ↓
构建查询条件 (LambdaQueryWrapper)
  ↓
转换状态枚举 (String → Integer)
  ↓
分页查询 (wms_valve)
  ↓
数据转换 (Valve → PdaValveInfo)
  ↓
转换状态枚举 (Integer → String)
  ↓
格式化日期 (Date → String)
  ↓
生成物料编码
  ↓
构建响应DTO
  ↓
返回JSON响应
```

### 9.5 任务查询接口数据流

```
PDA请求 (查询条件)
  ↓
参数校验 (@Valid)
  ↓
构建查询条件 (LambdaQueryWrapper)
  ↓
处理日期范围 (默认当天)
  ↓
转换任务类型枚举 (String → Integer)
  ↓
转换任务状态枚举 (String → Integer)
  ↓
分页查询 (wms_agv_task)
  ↓
数据转换 (AgvTask → PdaTaskInfo)
  ↓
转换任务类型枚举 (Integer → String)
  ↓
转换任务状态枚举 (Integer → String)
  ↓
格式化日期时间 (Date → String)
  ↓
构建响应DTO
  ↓
返回JSON响应
```

---

## 10. 数据库表关系

### 10.1 托盘扫码涉及的表

```
wms_barcode (条码表)
  ├─ barcode: 条码编号
  ├─ object_code: 关联对象编号 → wms_pallet.pallet_code
  └─ object_type: 关联对象类型 ("pallet")

wms_pallet (托盘表)
  ├─ pallet_code: 托盘编号
  ├─ pallet_type_id: 托盘类型ID → wms_pallet_type.id
  └─ current_bin_code: 当前库位编号

wms_pallet_type (托盘类型表)
  ├─ id: 主键
  └─ type_code: 类型编号 (SMALL/LARGE)
```

### 10.2 阀门绑定涉及的表

```
wms_valve (阀门表)
  ├─ valve_no: 阀门编号 (唯一)
  ├─ model: 阀门型号
  ├─ manufacturer: 厂家名称
  ├─ production_date: 生产日期
  ├─ pallet_id: 托盘ID → wms_pallet.id
  ├─ pallet_code: 托盘编号
  ├─ current_bin_id: 库位ID → wms_bin.id
  ├─ current_bin_code: 库位编号
  └─ status: 状态 (0=在库)

wms_pallet (托盘表)
  ├─ id: 主键
  ├─ is_bound: 是否绑定物料 (0/1)
  └─ is_empty: 是否空托 (0/1)

wms_bin (库位表)
  ├─ id: 主键
  └─ bin_code: 库位编号
```

### 10.3 阀门查询涉及的表

```
wms_valve (阀门表)
  ├─ valve_no: 阀门编号
  ├─ model: 阀门型号
  ├─ manufacturer: 厂家名称
  ├─ production_date: 生产日期
  ├─ pallet_code: 托盘编号
  ├─ current_bin_code: 库位编号
  └─ status: 状态
```

### 10.4 任务查询涉及的表

```
wms_agv_task (AGV任务表)
  ├─ task_no: 任务编号
  ├─ task_type: 任务类型 (1/2/3/4)
  ├─ status: 任务状态 (0/1/2/3/4)
  ├─ pallet_code: 托盘编号
  ├─ to_bin_code: 目标库位编号
  └─ create_time: 创建时间
```

---

## 11. 配置说明

### 11.1 Token有效期配置

- **配置项**：`sa-token.timeout`
- **默认值**：`86400`（24小时，单位：秒）
- **位置**：`application.yml`
- **说明**：控制Token的有效期

### 11.2 库前置换区站点编码配置

- **配置项**：`wms.swap-station.default`
- **默认值**：`WAREHOUSE_SWAP_1`
- **位置**：`application.yml`
- **说明**：库前置换区站点编码，用于AGV任务

---

## 12. 注意事项

### 12.1 数据一致性

1. **阀门绑定**：使用事务确保阀门和托盘状态同时更新
2. **状态管理**：阀门状态需要与业务流程同步更新
3. **库位匹配**：绑定阀门时需校验托盘库位与请求库位一致

### 12.2 性能优化

1. **分页查询**：所有查询接口都支持分页，避免一次性返回大量数据
2. **索引优化**：关键字段（如`valve_no`、`pallet_code`、`bin_code`）已建立索引
3. **查询条件**：使用MyBatis-Plus的Lambda表达式，避免SQL注入

### 12.3 扩展性

1. **物料编码**：当前临时生成，后续可从物料类型表关联查询
2. **置换区站点**：当前使用配置，后续可从库位表或配置表动态获取
3. **任务关联**：任务查询中的阀门信息，后续可从关联表查询

---

**文档版本**：v1.0  
**最后更新**：2025-01-15  
**维护人员**：WMS开发团队

