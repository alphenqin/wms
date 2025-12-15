# PDA登录账号说明

## 概述

PDA登录接口使用的账号密码来自于 **系统用户表（`sys_user`）**，与WMS后台管理系统使用的是同一套用户体系。

---

## 账号密码验证流程

### 1. 数据来源

PDA登录验证使用的是 **`sys_user`** 表中的用户数据：

| 字段名 | 说明 | 示例 |
|--------|------|------|
| `user_name` | 用户账号（登录用户名） | "admin" |
| `password` | 密码（BCrypt加密存储） | "$2a$10$7JB720yubVSZvUI0rEqK/..." |
| `status` | 账号状态（0正常 1停用） | "0" |
| `del_flag` | 删除标志（0存在 2删除） | "0" |

### 2. 验证流程

```
PDA发送登录请求
  ↓
接收用户名和密码
  ↓
从 sys_user 表查询用户（根据 user_name）
  ↓
检查用户是否存在
  ↓
检查账号状态（status = '0' 正常）
  ↓
使用 BCrypt 验证密码
  ↓
生成 Token
  ↓
返回登录成功响应
```

### 3. 代码实现

**位置**：`PdaApiController.login()`

```java
// 调用登录服务
String token = loginService.login(
    request.getUsername(),  // 用户名
    request.getPassword(),   // 密码
    "",                      // 验证码（PDA登录不验证）
    ""                       // UUID（PDA登录不验证）
);
```

**内部处理**（`SysLoginService.login()`）：

```java
// 1. 从 sys_user 表查询用户
SysUserVo user = loadUserByUsername(username);
// SQL: SELECT * FROM sys_user WHERE user_name = ?

// 2. 检查用户是否存在
if (user == null) {
    throw new UserException("user.not.exists", username);
}

// 3. 检查账号状态
if (UserStatus.DISABLE.getCode().equals(user.getStatus())) {
    throw new UserException("user.blocked", username);
}

// 4. 验证密码（使用 BCrypt）
BCrypt.checkpw(password, user.getPassword());

// 5. 生成 Token
LoginHelper.loginByDevice(loginUser, DeviceType.PC);
```

---

## 数据库表结构

### sys_user 表

```sql
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(10) DEFAULT 'sys_user' COMMENT '用户类型',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `password` varchar(100) DEFAULT '' COMMENT '密码（BCrypt加密）',
  `status` char(1) DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';
```

---

## 如何使用

### 1. 使用现有账号

如果WMS系统中已经有用户账号，可以直接使用该账号登录PDA：

**示例**：
- 用户名：`admin`
- 密码：`admin123`（或该账号的实际密码）

### 2. 创建新账号

如果需要为PDA创建专用账号，可以通过以下方式：

#### 方式一：通过WMS后台管理系统创建

1. 登录WMS后台管理系统
2. 进入"系统管理" → "用户管理"
3. 点击"新增"按钮
4. 填写用户信息：
   - 用户账号：如 `pda001`
   - 用户昵称：如 `PDA操作员`
   - 密码：设置登录密码
   - 部门：选择所属部门
   - 角色：分配相应角色（可选）
5. 保存

#### 方式二：直接插入数据库

```sql
INSERT INTO sys_user (
    user_id, 
    user_name, 
    nick_name, 
    password, 
    status, 
    del_flag,
    create_time
) VALUES (
    -- 使用自增ID或指定ID
    'pda001',                    -- 用户账号
    'PDA操作员',                 -- 用户昵称
    '$2a$10$...',               -- BCrypt加密后的密码
    '0',                         -- 状态：0正常
    '0',                         -- 删除标志：0存在
    NOW()                        -- 创建时间
);
```

**注意**：密码需要使用BCrypt加密，可以使用以下Java代码生成：

```java
import cn.dev33.satoken.secure.BCrypt;

String password = "123456";  // 原始密码
String hashedPassword = BCrypt.hashpw(password);  // BCrypt加密
System.out.println(hashedPassword);
```

---

## 密码加密说明

### BCrypt加密

系统使用 **BCrypt** 算法对密码进行加密存储，这是一种单向哈希算法，具有以下特点：

1. **安全性高**：即使数据库泄露，也无法直接还原原始密码
2. **自动加盐**：每次加密都会生成不同的盐值，相同密码的加密结果也不同
3. **验证方式**：使用 `BCrypt.checkpw(原始密码, 加密密码)` 进行验证

### 密码格式

BCrypt加密后的密码格式示例：
```
$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2
```

格式说明：
- `$2a$`：BCrypt版本标识
- `10`：加密轮数（cost factor）
- 后面是盐值和哈希值的组合

---

## 账号状态说明

### status 字段

| 值 | 说明 | 是否可登录 |
|---|------|-----------|
| `0` | 正常 | ✅ 可以登录 |
| `1` | 停用 | ❌ 不能登录 |

### del_flag 字段

| 值 | 说明 | 是否可登录 |
|---|------|-----------|
| `0` | 存在 | ✅ 可以登录 |
| `2` | 删除 | ❌ 不能登录 |

**注意**：只有 `status = '0'` 且 `del_flag = '0'` 的用户才能登录。

---

## 登录限制

### 1. 验证码

- **PDA登录**：不验证验证码（传入空字符串）
- **Web登录**：根据配置决定是否验证验证码

### 2. 密码错误次数限制

系统会记录密码错误次数，达到上限后会锁定账号：

- **配置项**：`user.password.maxRetryCount`（默认值需要查看配置）
- **锁定时间**：`user.password.lockTime`（默认值需要查看配置）
- **存储位置**：Redis缓存，key格式：`pwd_err_cnt:{username}:{ip}`

### 3. 登录日志

所有登录操作都会记录到 `sys_logininfor` 表中，包括：
- 登录账号
- 登录IP
- 登录时间
- 登录状态（成功/失败）
- 登录信息（成功/失败原因）

---

## 常见问题

### Q1: PDA登录和Web登录使用同一套账号吗？

**A**: 是的，PDA登录和Web后台登录使用的是同一套用户体系（`sys_user`表），账号密码通用。

### Q2: 如何为PDA创建专用账号？

**A**: 可以通过WMS后台管理系统的"用户管理"功能创建新用户，或者直接在数据库中插入用户记录（注意密码需要BCrypt加密）。

### Q3: 密码忘记了怎么办？

**A**: 可以通过以下方式重置密码：
1. 使用管理员账号在后台管理系统重置
2. 直接在数据库中更新密码字段（需要使用BCrypt加密）

### Q4: 如何修改密码？

**A**: 
1. 登录WMS后台管理系统，在"个人中心"修改密码
2. 管理员可以在"用户管理"中重置其他用户的密码

### Q5: 密码加密方式是什么？

**A**: 使用BCrypt算法，这是业界标准的密码哈希算法，安全性高。

### Q6: 可以禁用某个用户的PDA登录吗？

**A**: 可以，将用户的 `status` 字段设置为 `'1'`（停用），该用户将无法登录PDA和Web系统。

---

## 测试账号

根据数据库初始化脚本，系统默认有一个管理员账号：

- **用户名**：`admin`
- **密码**：需要查看初始化脚本或询问系统管理员
- **状态**：正常（`status = '0'`）

**注意**：生产环境请及时修改默认密码！

---

## 相关配置

### 密码策略配置

可以在 `application.yml` 中配置密码相关策略：

```yaml
user:
  password:
    maxRetryCount: 5      # 最大重试次数
    lockTime: 10          # 锁定时间（分钟）
```

### Token配置

```yaml
sa-token:
  timeout: 86400          # Token有效期（秒），默认24小时
```

---

## 总结

1. **PDA登录使用系统用户表（`sys_user`）**
2. **账号密码与Web后台管理系统通用**
3. **密码使用BCrypt加密存储**
4. **只有状态正常（`status='0'`）且未删除（`del_flag='0'`）的用户才能登录**
5. **可以通过WMS后台管理系统创建和管理用户账号**

---

**文档版本**：v1.0  
**最后更新**：2025-01-15  
**维护人员**：WMS开发团队

