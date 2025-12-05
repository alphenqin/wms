@echo off
chcp 65001 >nul
echo ========================================
echo WMS项目清理脚本
echo ========================================
echo.

echo [1/2] 正在删除后端无关模块...
if exist "wms-server\ruoyi-modules\ruoyi-demo" (
    echo   删除 ruoyi-demo 模块...
    rmdir /s /q "wms-server\ruoyi-modules\ruoyi-demo"
    echo   ✓ ruoyi-demo 已删除
) else (
    echo   - ruoyi-demo 不存在，跳过
)

if exist "wms-server\ruoyi-modules\ruoyi-generator" (
    echo   删除 ruoyi-generator 模块...
    rmdir /s /q "wms-server\ruoyi-modules\ruoyi-generator"
    echo   ✓ ruoyi-generator 已删除
) else (
    echo   - ruoyi-generator 不存在，跳过
)

echo.
echo [2/2] 正在删除前端无关目录...
if exist "wms-web\src\api\demo" (
    echo   删除 api/demo 目录...
    rmdir /s /q "wms-web\src\api\demo"
    echo   ✓ api/demo 已删除
) else (
    echo   - api/demo 不存在，跳过
)

if exist "wms-web\src\api\monitor" (
    echo   删除 api/monitor 目录...
    rmdir /s /q "wms-web\src\api\monitor"
    echo   ✓ api/monitor 已删除
) else (
    echo   - api/monitor 不存在，跳过
)

if exist "wms-web\src\api\tool" (
    echo   删除 api/tool 目录...
    rmdir /s /q "wms-web\src\api\tool"
    echo   ✓ api/tool 已删除
) else (
    echo   - api/tool 不存在，跳过
)

if exist "wms-web\src\views\demo" (
    echo   删除 views/demo 目录...
    rmdir /s /q "wms-web\src\views\demo"
    echo   ✓ views/demo 已删除
) else (
    echo   - views/demo 不存在，跳过
)

if exist "wms-web\src\views\monitor" (
    echo   删除 views/monitor 目录...
    rmdir /s /q "wms-web\src\views\monitor"
    echo   ✓ views/monitor 已删除
) else (
    echo   - views/monitor 不存在，跳过
)

if exist "wms-web\src\views\tool" (
    echo   删除 views/tool 目录...
    rmdir /s /q "wms-web\src\views\tool"
    echo   ✓ views/tool 已删除
) else (
    echo   - views/tool 不存在，跳过
)

echo.
echo ========================================
echo 清理完成！
echo ========================================
echo.
echo 已删除的内容：
echo   - 后端：ruoyi-demo, ruoyi-generator 模块
echo   - 前端：demo, monitor, tool 相关页面和API
echo.
echo 已更新的配置：
echo   - pom.xml 文件（移除相关依赖）
echo   - router/index.js（移除相关路由）
echo.
pause

