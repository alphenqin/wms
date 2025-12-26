#!/bin/bash

echo "========================================"
echo "直接安装依赖（不安装包管理器）"
echo "========================================"
echo ""

echo "[1/3] 停止可能正在运行的进程..."
pkill -f node 2>/dev/null || true
echo "   完成"
echo ""

echo "[2/3] 清除缓存和旧文件..."
npm cache clean --force 2>/dev/null || true
rm -rf node_modules package-lock.json 2>/dev/null || true
echo "   完成"
echo ""

echo "[3/3] 使用 npm 直接安装（带超时和重试）..."
echo "   镜像源: https://registry.npmmirror.com"
echo "   正在安装，请耐心等待..."
echo ""

# 设置超时和重试
export NPM_CONFIG_FETCH_TIMEOUT=600000
export NPM_CONFIG_FETCH_RETRIES=5
export NPM_CONFIG_REGISTRY=https://registry.npmmirror.com

# 使用 npm 安装，显示进度
npm install --registry=https://registry.npmmirror.com --prefer-offline --no-audit --progress=false

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "安装成功！"
    echo "========================================"
    echo ""
    echo "运行项目:"
    echo "  npm run dev"
else
    echo ""
    echo "========================================"
    echo "安装失败"
    echo "========================================"
    echo ""
    echo "建议："
    echo "1. 检查网络: ping registry.npmmirror.com"
    echo "2. 尝试使用 yarn: ./install-yarn.sh"
    echo "3. 查看详细错误: npm install --verbose"
fi

