# WMS数据库初始化完整指南

## ✅ 重要说明

**只需执行 `wms.sql` 一个文件即可！** 

`wms.sql` 已包含所有必需内容（表结构 + 菜单配置 + 字典配置），无需执行其他SQL文件。

## 📋 SQL脚本说明

### wms.sql（唯一需要执行的脚本）✅

**作用：** 完整初始化WMS系统数据库

**包含内容：**
1. ✅ **所有表结构**
   - 系统基础表（sys_*）- 用户、角色、菜单、字典等（17个表）
   - WMS业务表（wms_*）- 所有WMS业务相关表（16个表）
   - 代码生成表（gen_*）- 已删除generator模块，但表结构保留（不影响运行）

2. ✅ **WMS菜单配置**
   - WMS主菜单和所有子菜单（菜单ID从2000开始）
   - 包含菜单路径、组件、权限标识等

3. ✅ **WMS字典配置**
   - 字典类型和字典数据（字典类型ID从100开始）
   - 包含货位状态、托盘状态、任务状态等

## 🚀 执行步骤

### 方法1：使用MySQL命令行（推荐）

```bash
# 1. 登录MySQL
mysql -u root -p

# 2. 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS `ry-wms` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

# 3. 选择数据库
USE `ry-wms`;

# 4. 执行SQL脚本（只需执行一个文件）
SOURCE /path/to/wms.sql;
```

### 方法2：使用数据库管理工具（Navicat、DBeaver等）

1. **创建数据库**
   - 数据库名：`ry-wms`（或自定义）
   - 字符集：`utf8mb4`
   - 排序规则：`utf8mb4_general_ci`

2. **执行SQL脚本**
   - 执行 `wms.sql` - 一次性完成所有初始化（表结构 + 菜单 + 字典）

### 方法3：使用命令行直接执行

```bash
# Windows/Linux/Mac
mysql -u root -p ry-wms < wms.sql
```

## ✅ 执行说明

**只需执行 `wms.sql` 一个文件即可！**

`wms.sql` 已包含：
1. ✅ 所有表结构（系统表 + WMS业务表）
2. ✅ WMS菜单配置
3. ✅ WMS字典配置

**执行顺序：** 无需考虑顺序，因为所有内容都在一个文件中，按顺序执行。

## 🔍 验证执行结果

### 1. 检查表是否创建成功

```sql
-- 检查系统表
SHOW TABLES LIKE 'sys_%';

-- 检查WMS业务表
SHOW TABLES LIKE 'wms_%';

-- 应该看到：
-- sys_user, sys_role, sys_menu, sys_dict_type, sys_dict_data 等
-- wms_warehouse, wms_area, wms_bin, wms_pallet 等（共16个）
```

### 2. 检查菜单是否插入成功

```sql
-- 检查WMS菜单
SELECT menu_id, menu_name, parent_id, path, component 
FROM sys_menu 
WHERE menu_id >= 2000 
ORDER BY menu_id;

-- 应该看到WMS主菜单（menu_id=2000）和所有子菜单
```

### 3. 检查字典是否插入成功

```sql
-- 检查WMS字典类型
SELECT dict_id, dict_name, dict_type 
FROM sys_dict_type 
WHERE dict_id >= 100 
ORDER BY dict_id;

-- 检查WMS字典数据
SELECT dict_code, dict_label, dict_type 
FROM sys_dict_data 
WHERE dict_code >= 1001 
ORDER BY dict_code;
```

### 4. 检查默认用户

```sql
-- 检查默认管理员用户
SELECT user_id, user_name, nick_name, status 
FROM sys_user 
WHERE user_name = 'admin';

-- 默认密码：admin123（需要首次登录后修改）
```

## ⚠️ 常见问题

### 1. 执行wms.sql时报错"Duplicate entry"
**原因：** 菜单ID或字典ID已存在（可能之前执行过）
**解决：** 
- 删除已存在的菜单：`DELETE FROM sys_menu WHERE menu_id >= 2000;`
- 删除已存在的字典类型：`DELETE FROM sys_dict_type WHERE dict_id >= 100;`
- 删除已存在的字典数据：`DELETE FROM sys_dict_data WHERE dict_code >= 1001;`
- 然后重新执行 `wms.sql`

### 4. 代码生成表（gen_table）报错
**原因：** 已删除generator模块，但表结构还在
**解决：** 
- 可以忽略（不影响WMS功能）
- 或手动删除：`DROP TABLE IF EXISTS gen_table, gen_table_column;`

## 📊 数据库表统计

执行完成后，数据库应包含：

- **系统表**：17个（sys_*）
- **代码生成表**：2个（gen_*，可选删除）
- **WMS业务表**：16个（wms_*）
- **总计**：35个表

## 🎯 执行完成后的下一步

1. ✅ 配置 `application-dev.yml` 中的数据库连接信息
2. ✅ 启动后端服务
3. ✅ 使用默认账号登录：`admin` / `admin123`
4. ✅ 检查WMS菜单是否显示
5. ✅ 测试WMS各功能模块

## 📝 注意事项

1. **备份数据**：如果数据库已有数据，执行前请先备份
2. **字符集**：确保数据库使用 `utf8mb4` 字符集
3. **权限**：确保数据库用户有CREATE、INSERT、DROP权限
4. **菜单ID冲突**：如果系统已有菜单ID 2000+，需要调整 `wms.sql` 中菜单部分的ID
5. **字典ID冲突**：如果系统已有字典ID 100+，需要调整 `wms.sql` 中字典部分的ID

---

**总结：只需执行 `wms.sql` 一个文件即可完整初始化WMS系统！所有表结构、菜单配置和字典配置都已包含在内。**

