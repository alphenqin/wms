# PDA登录问题排查指南

## 问题描述

PDA登录时返回400错误："用户名或密码错误"

**错误响应示例：**
```json
{
  "code": 400,
  "msg": "用户名或密码错误",
  "detailMessage": null,
  "data": null
}
```

---

## 已修复的问题

### ✅ 验证码问题（已修复）

**问题原因**：
- 当系统验证码开关开启时，即使PDA传入空字符串，系统仍会检查Redis中的验证码
- 如果Redis中没有对应的验证码，会抛出`CaptchaExpireException`异常
- 异常被统一捕获后返回"用户名或密码错误"，掩盖了真正的问题

**修复方案**：
- 在`SysLoginService`中新增了`pdaLogin()`方法，专门用于PDA登录
- 该方法跳过验证码检查，直接验证用户名和密码
- PDA登录接口现在调用`pdaLogin()`而不是`login()`

**修复后的代码**：
```java
// SysLoginService.java
public String pdaLogin(String username, String password) {
    // 跳过验证码检查，直接验证用户名和密码
    SysUserVo user = loadUserByUsername(username);
    checkLogin(LoginType.PASSWORD, username, () -> !BCrypt.checkpw(password, user.getPassword()));
    LoginUser loginUser = buildLoginUser(user);
    LoginHelper.loginByDevice(loginUser, DeviceType.APP);
    // ...
    return StpUtil.getTokenValue();
}
```

---

## 常见问题排查

### 1. 用户名或密码错误

#### 检查步骤：

**步骤1：确认用户名存在**
```sql
SELECT user_id, user_name, nick_name, status, del_flag 
FROM sys_user 
WHERE user_name = 'admin';
```

**步骤2：检查账号状态**
- `status = '0'`：正常（可以登录）
- `status = '1'`：停用（不能登录）
- `del_flag = '0'`：存在（可以登录）
- `del_flag = '2'`：删除（不能登录）

**步骤3：验证密码**
- 密码使用BCrypt加密存储
- 不能直接查看明文密码
- 可以通过以下方式重置密码：

```java
// 生成BCrypt加密密码
import cn.dev33.satoken.secure.BCrypt;
String hashedPassword = BCrypt.hashpw("新密码");
System.out.println(hashedPassword);
```

然后在数据库中更新：
```sql
UPDATE sys_user 
SET password = '$2a$10$...'  -- 使用上面生成的加密密码
WHERE user_name = 'admin';
```

**步骤4：检查密码错误次数限制**
- 系统会记录密码错误次数
- 达到上限后会锁定账号一段时间
- 检查Redis中的错误次数：
  ```bash
  # 查看错误次数（key格式：pwd_err_cnt:{username}:{ip}）
  redis-cli
  GET pwd_err_cnt:admin:10.0.2.2
  ```
- 如果达到上限，需要等待锁定时间过后再试，或清除Redis中的错误记录

### 2. 用户不存在

**错误信息**：`"user.not.exists"`

**检查方法**：
```sql
SELECT * FROM sys_user WHERE user_name = 'admin';
```

**解决方法**：
- 确认用户名拼写正确（区分大小写）
- 如果用户不存在，需要创建用户账号

### 3. 账号被停用

**错误信息**：`"user.blocked"`

**检查方法**：
```sql
SELECT user_name, status, del_flag 
FROM sys_user 
WHERE user_name = 'admin';
```

**解决方法**：
```sql
-- 启用账号
UPDATE sys_user 
SET status = '0' 
WHERE user_name = 'admin';
```

### 4. 数据库连接问题

**检查方法**：
- 查看后端日志，确认数据库连接是否正常
- 检查`docker-compose.yml`中的MySQL配置

**解决方法**：
- 确认MySQL服务正常运行
- 检查数据库连接配置

### 5. Redis连接问题

**检查方法**：
- 查看后端日志，确认Redis连接是否正常
- 检查`docker-compose.yml`中的Redis配置

**解决方法**：
- 确认Redis服务正常运行
- 检查Redis连接配置

---

## 调试方法

### 1. 查看后端日志

**日志位置**：
- Docker容器：`./wms-server/logs/`
- 本地运行：项目根目录下的`logs/`文件夹

**查看登录相关日志**：
```bash
# 查看最近的错误日志
tail -f logs/sys-error.log

# 查看登录日志
grep "PDA登录" logs/sys-info.log
```

### 2. 检查数据库中的用户数据

```sql
-- 查看admin用户信息
SELECT 
    user_id,
    user_name,
    nick_name,
    password,
    status,
    del_flag,
    create_time
FROM sys_user 
WHERE user_name = 'admin';
```

### 3. 测试密码验证

可以使用以下Java代码测试密码是否正确：

```java
import cn.dev33.satoken.secure.BCrypt;

// 从数据库获取的加密密码
String hashedPassword = "$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2";
// 用户输入的密码
String inputPassword = "admin123";

// 验证密码
boolean matches = BCrypt.checkpw(inputPassword, hashedPassword);
System.out.println("密码匹配: " + matches);
```

### 4. 直接测试登录接口

使用Postman或curl测试：

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123",
    "deviceCode": "PDA-01"
  }'
```

---

## 快速解决方案

### 方案1：重置admin密码

如果确认用户名正确，但密码不确定，可以重置密码：

**步骤1：生成新密码的BCrypt哈希**
```java
import cn.dev33.satoken.secure.BCrypt;
String newPassword = "admin123";  // 新密码
String hashed = BCrypt.hashpw(newPassword);
System.out.println(hashed);
```

**步骤2：更新数据库**
```sql
UPDATE sys_user 
SET password = '生成的BCrypt哈希值'
WHERE user_name = 'admin';
```

### 方案2：创建新的PDA专用账号

```sql
-- 创建PDA专用账号
INSERT INTO sys_user (
    user_id,
    user_name,
    nick_name,
    password,
    status,
    del_flag,
    create_time,
    create_by
) VALUES (
    -- 使用自增ID或指定ID（需要确保不重复）
    'pda001',                    -- 用户账号
    'PDA操作员',                 -- 用户昵称
    '$2a$10$...',               -- BCrypt加密后的密码（需要先生成）
    '0',                         -- 状态：0正常
    '0',                         -- 删除标志：0存在
    NOW(),                       -- 创建时间
    'admin'                      -- 创建人
);
```

**注意**：需要先使用Java代码生成BCrypt加密密码。

### 方案3：检查并修复账号状态

```sql
-- 确保账号状态正常
UPDATE sys_user 
SET status = '0',      -- 正常
    del_flag = '0'     -- 未删除
WHERE user_name = 'admin';
```

---

## 验证修复

修复后，使用以下请求测试：

```json
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123",
  "deviceCode": "PDA-01"
}
```

**成功响应**：
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expireAt": "2025-01-15 23:59:59",
    "userName": "管理员",
    "roles": ["admin"]
  }
}
```

---

## 常见错误码说明

| 错误码 | 说明 | 可能原因 |
|--------|------|----------|
| 400 | 请求参数错误 | 用户名或密码错误、账号停用、用户不存在 |
| 401 | 未授权 | Token无效或过期 |
| 404 | 资源不存在 | 用户不存在 |
| 500 | 服务器内部错误 | 数据库连接失败、系统异常 |

---

## 联系支持

如果以上方法都无法解决问题，请：

1. **收集日志**：
   - 后端错误日志（`logs/sys-error.log`）
   - 后端信息日志（`logs/sys-info.log`）
   - PDA端的请求和响应日志

2. **提供信息**：
   - 用户名
   - 错误发生时间
   - 完整的错误响应
   - 相关日志片段

3. **联系开发团队**进行进一步排查

---

**文档版本**：v1.0  
**最后更新**：2025-01-15  
**维护人员**：WMS开发团队

