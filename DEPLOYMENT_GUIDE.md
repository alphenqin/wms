# WMS系统部署指南

## 一、环境要求

### 后端环境
- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Redis 6.0+

### 前端环境
- Node.js 16+
- npm 或 yarn

## 二、数据库初始化

### 1. 创建数据库
```sql
CREATE DATABASE wms CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

### 2. 执行SQL脚本
按以下顺序执行SQL脚本（在 `wms-server/script/sql/` 目录下）：

1. **系统基础表**（若依框架自带）
   - 执行若依框架的初始化SQL脚本

2. **WMS业务表**
   ```bash
   mysql -u root -p wms < wms-server/script/sql/wms.sql
   ```

3. **菜单配置**
   ```bash
   mysql -u root -p wms < wms-server/script/sql/menu.sql
   ```
   注意：需要根据实际系统菜单表结构调整菜单ID

4. **字典配置**
   ```bash
   mysql -u root -p wms < wms-server/script/sql/dict.sql
   ```
   注意：需要根据实际系统字典表结构调整字典ID

## 三、后端部署

### 1. 修改配置文件

编辑 `wms-server/ruoyi-admin-wms/src/main/resources/application-dev.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/wms?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
    username: root
    password: your_password
  
  redis:
    host: localhost
    port: 6379
    password: your_redis_password
```

### 2. 编译打包

```bash
cd wms-server
mvn clean package -DskipTests
```

### 3. 运行

**开发环境：**
```bash
cd ruoyi-admin-wms
mvn spring-boot:run
```

**生产环境：**
```bash
java -jar ruoyi-admin-wms/target/ruoyi-admin-wms.jar
```

### 4. Docker部署（可选）

使用提供的 `docker-compose.yml`：

```bash
docker-compose up -d
```

## 四、前端部署

### 1. 安装依赖

```bash
cd wms-web
npm install
# 或
yarn install
```

### 2. 修改API地址

编辑 `wms-web/.env.development`：

```env
VITE_APP_BASE_API = '/dev-api'
VITE_APP_CONTEXT_PATH = '/'
```

### 3. 开发环境运行

```bash
npm run dev
# 或
yarn dev
```

### 4. 生产环境构建

```bash
npm run build:prod
# 或
yarn build:prod
```

构建产物在 `wms-web/dist` 目录。

### 5. Nginx配置

将构建产物部署到Nginx，配置示例：

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /path/to/wms-web/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /dev-api {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

## 五、系统配置

### 1. 菜单配置

1. 登录系统管理后台
2. 进入"系统管理" -> "菜单管理"
3. 执行 `menu.sql` 脚本或手动添加菜单
4. 配置菜单权限

### 2. 字典配置

1. 进入"系统管理" -> "字典管理"
2. 执行 `dict.sql` 脚本或手动添加字典
3. 配置字典数据

### 3. 角色权限配置

1. 进入"系统管理" -> "角色管理"
2. 创建WMS相关角色（如：WMS管理员、库管员等）
3. 分配菜单权限和按钮权限

### 4. WMS系统配置

1. 进入"WMS仓储管理" -> "系统配置" -> "WMS配置"
2. 配置AGV接口地址、PDA配置等
3. 配置业务参数和规则

## 六、功能验证

### 1. 基础数据验证
- [ ] 创建仓库
- [ ] 创建货区
- [ ] 创建货位
- [ ] 创建物料类型
- [ ] 创建托盘类型
- [ ] 创建托盘
- [ ] 创建阀门

### 2. 业务功能验证
- [ ] 创建入库单
- [ ] 创建出库单
- [ ] 创建移库单
- [ ] 创建盘点单
- [ ] 库存查询
- [ ] 报表查询

### 3. 集成功能验证
- [ ] AGV任务下发
- [ ] PDA操作记录
- [ ] 数据备份

## 七、常见问题

### 1. 数据库连接失败
- 检查数据库服务是否启动
- 检查数据库用户名密码是否正确
- 检查数据库是否已创建

### 2. Redis连接失败
- 检查Redis服务是否启动
- 检查Redis密码是否正确
- 检查防火墙设置

### 3. 前端接口404
- 检查后端服务是否启动
- 检查API代理配置是否正确
- 检查跨域配置

### 4. 菜单不显示
- 检查菜单SQL是否执行成功
- 检查角色权限是否配置
- 检查菜单状态是否为"正常"

### 5. 字典不显示
- 检查字典SQL是否执行成功
- 检查字典类型是否正确
- 检查字典状态是否为"正常"

## 八、性能优化建议

1. **数据库优化**
   - 为常用查询字段添加索引
   - 定期清理历史数据
   - 配置数据库连接池

2. **Redis优化**
   - 配置Redis持久化
   - 设置合理的过期时间
   - 使用Redis集群（生产环境）

3. **前端优化**
   - 启用Gzip压缩
   - 配置CDN加速
   - 使用懒加载

4. **后端优化**
   - 配置JVM参数
   - 启用缓存
   - 优化SQL查询

## 九、安全建议

1. **数据库安全**
   - 使用强密码
   - 限制数据库访问IP
   - 定期备份数据

2. **应用安全**
   - 配置HTTPS
   - 启用CSRF防护
   - 配置访问日志

3. **权限安全**
   - 遵循最小权限原则
   - 定期审查权限配置
   - 启用操作日志

## 十、维护建议

1. **日常维护**
   - 定期备份数据库
   - 监控系统日志
   - 检查系统性能

2. **数据维护**
   - 定期清理过期数据
   - 归档历史数据
   - 优化数据库索引

3. **版本更新**
   - 备份数据库和代码
   - 测试新版本功能
   - 逐步升级部署

