# 项目清理脚本说明

## 已自动删除的内容

### 前端已删除
- ✅ `wms-web/src/api/demo/` - demo API文件
- ✅ `wms-web/src/api/tool/gen.js` - 代码生成API
- ✅ `wms-web/src/api/monitor/` - 监控相关API
- ✅ `wms-web/src/views/demo/` - demo页面
- ✅ `wms-web/src/views/monitor/` - 监控页面
- ✅ `wms-web/src/views/tool/` - 工具页面

### 后端配置已更新
- ✅ `wms-server/ruoyi-modules/pom.xml` - 已移除demo和generator模块
- ✅ `wms-server/pom.xml` - 已移除demo依赖
- ✅ `wms-server/ruoyi-admin-wms/pom.xml` - 已移除generator依赖

## 需要手动删除的目录

由于工具限制，以下目录需要手动删除：

### 后端模块目录
```bash
# Windows PowerShell
Remove-Item -Recurse -Force "wms-server\ruoyi-modules\ruoyi-demo"
Remove-Item -Recurse -Force "wms-server\ruoyi-modules\ruoyi-generator"

# Linux/Mac
rm -rf wms-server/ruoyi-modules/ruoyi-demo
rm -rf wms-server/ruoyi-modules/ruoyi-generator
```

### 前端目录（如果还存在）
```bash
# Windows PowerShell
Remove-Item -Recurse -Force "wms-web\src\views\demo"
Remove-Item -Recurse -Force "wms-web\src\views\monitor"
Remove-Item -Recurse -Force "wms-web\src\views\tool"
Remove-Item -Recurse -Force "wms-web\src\api\demo"
Remove-Item -Recurse -Force "wms-web\src\api\monitor"
Remove-Item -Recurse -Force "wms-web\src\api\tool"

# Linux/Mac
rm -rf wms-web/src/views/demo
rm -rf wms-web/src/views/monitor
rm -rf wms-web/src/views/tool
rm -rf wms-web/src/api/demo
rm -rf wms-web/src/api/monitor
rm -rf wms-web/src/api/tool
```

## 清理后的项目结构

### 保留的模块
- ✅ `ruoyi-system` - 系统管理模块（用户、角色、菜单、字典等，WMS需要）
- ✅ `ruoyi-common` - 通用模块（框架基础，必须保留）
- ✅ `ruoyi-admin-wms` - WMS主应用
- ✅ `wms` 包下的所有业务代码

### 已删除的模块
- ❌ `ruoyi-demo` - 演示模块（与WMS业务无关）
- ❌ `ruoyi-generator` - 代码生成器（可选，已移除）

### 保留的前端页面
- ✅ `wms/` - 所有WMS业务页面
- ✅ `system/` - 系统管理页面（用户、角色、菜单等）
- ✅ `dashboard/` - 数据大屏
- ✅ `error/` - 错误页面（404、401）
- ✅ `login.vue` - 登录页面
- ✅ `register.vue` - 注册页面

### 已删除的前端页面
- ❌ `demo/` - 演示页面
- ❌ `monitor/` - 监控页面（与WMS业务无关）
- ❌ `tool/` - 工具页面（代码生成等）

## 验证清理结果

清理完成后，请验证：

1. **编译检查**
   ```bash
   cd wms-server
   mvn clean compile
   ```

2. **前端检查**
   ```bash
   cd wms-web
   npm run build
   ```

3. **功能测试**
   - 登录系统
   - 访问WMS各功能模块
   - 确认系统管理功能正常

## 注意事项

1. **系统管理模块保留**：`ruoyi-system` 模块必须保留，因为WMS需要用户、角色、菜单、字典等基础功能。

2. **通用模块保留**：`ruoyi-common` 下的所有模块都是框架基础，必须保留。

3. **如果后续需要代码生成器**：可以重新添加 `ruoyi-generator` 模块。

4. **监控功能**：如果后续需要系统监控功能，可以重新添加 `monitor` 相关页面和API。

