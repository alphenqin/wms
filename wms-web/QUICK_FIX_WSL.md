# npm install 卡住问题快速解决 (WSL)

## 🚨 立即操作

### 步骤1：强制停止当前进程

**按 `Ctrl + C` 强制停止当前的 npm install**

如果按了没反应，打开新的终端窗口执行：
```bash
# 停止所有 node 进程
pkill -f node
```

### 步骤2：使用提供的安装脚本（推荐）

**方法1：使用 yarn（推荐，更快）**
```bash
cd wms-web
./install-yarn.sh
```

**方法2：使用 pnpm（最快）**
```bash
cd wms-web
./install-pnpm.sh
```

**方法3：使用优化后的 npm**
```bash
cd wms-web
./install.sh
```

## 🔧 手动解决步骤

### 1. 清除所有缓存和文件

```bash
cd wms-web

# 停止所有 node 进程
pkill -f node

# 清除 npm 缓存
npm cache clean --force

# 删除 node_modules 和 lock 文件
rm -rf node_modules package-lock.json
```

### 2. 使用 yarn 安装（推荐）

```bash
# 安装 yarn（如果还没有）
npm install -g yarn --registry=https://registry.npmmirror.com

# 配置镜像源
yarn config set registry https://registry.npmmirror.com

# 安装依赖
yarn install
```

### 3. 或使用 pnpm（最快）

```bash
# 安装 pnpm
npm install -g pnpm --registry=https://registry.npmmirror.com

# 配置镜像源
pnpm config set registry https://registry.npmmirror.com

# 安装依赖
pnpm install
```

## 🐛 如果还是卡住

### 检查网络

```bash
# 测试镜像源连接
ping registry.npmmirror.com

# 如果 ping 不通，尝试其他镜像源
npm config set registry https://mirrors.cloud.tencent.com/npm/
```

### 使用代理（如果有）

```bash
# 设置代理
npm config set proxy http://127.0.0.1:7890
npm config set https-proxy http://127.0.0.1:7890

# 安装
npm install
```

### 检查 WSL 网络配置

```bash
# 检查 DNS
cat /etc/resolv.conf

# 如果 DNS 有问题，可以临时设置
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

## 📊 性能对比

| 方法 | 预计时间 | 推荐度 |
|------|---------|--------|
| npm（官方源） | 10-30分钟 | ⭐ |
| npm（淘宝镜像） | 3-8分钟 | ⭐⭐ |
| yarn（淘宝镜像） | 1-3分钟 | ⭐⭐⭐⭐ |
| pnpm（淘宝镜像） | 1-2分钟 | ⭐⭐⭐⭐⭐ |

## ✅ 验证安装成功

安装完成后检查：

```bash
# 检查 node_modules 是否存在
ls -la node_modules

# 检查关键依赖
ls node_modules/vue
ls node_modules/element-plus

# 运行项目
npm run dev
# 或
yarn dev
# 或
pnpm dev
```

## 💡 建议

**强烈推荐使用 yarn 或 pnpm**，它们比 npm 快很多，而且更稳定。

## 🔍 排查步骤

如果所有方法都失败：

1. **检查 Node.js 版本**
   ```bash
   node -v  # 应该是 16+ 或 18+
   npm -v
   ```

2. **检查网络连接**
   ```bash
   curl -I https://registry.npmmirror.com
   ```

3. **查看详细日志**
   ```bash
   npm install --verbose 2>&1 | tee install.log
   ```

4. **尝试单个包安装**
   ```bash
   npm install vue@3.2.45 --registry=https://registry.npmmirror.com
   ```

