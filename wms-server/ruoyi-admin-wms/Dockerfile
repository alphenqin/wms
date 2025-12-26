# ============================================
# 第一阶段：构建阶段（使用 Maven 构建项目）
# ============================================
FROM maven:3.9-eclipse-temurin-17 AS builder

# 设置工作目录
WORKDIR /build

# 复制根 pom.xml（利用 Docker 缓存层）
COPY pom.xml .

# 复制所有子模块的 pom.xml（利用 Docker 缓存层）
COPY ruoyi-admin-wms/pom.xml ./ruoyi-admin-wms/
COPY ruoyi-common/pom.xml ./ruoyi-common/
COPY ruoyi-modules/pom.xml ./ruoyi-modules/

# 复制 common 子模块的 pom.xml
COPY ruoyi-common/ruoyi-common-bom/pom.xml ./ruoyi-common/ruoyi-common-bom/
COPY ruoyi-common/ruoyi-common-core/pom.xml ./ruoyi-common/ruoyi-common-core/
COPY ruoyi-common/ruoyi-common-doc/pom.xml ./ruoyi-common/ruoyi-common-doc/
COPY ruoyi-common/ruoyi-common-encrypt/pom.xml ./ruoyi-common/ruoyi-common-encrypt/
COPY ruoyi-common/ruoyi-common-excel/pom.xml ./ruoyi-common/ruoyi-common-excel/
COPY ruoyi-common/ruoyi-common-idempotent/pom.xml ./ruoyi-common/ruoyi-common-idempotent/
COPY ruoyi-common/ruoyi-common-json/pom.xml ./ruoyi-common/ruoyi-common-json/
COPY ruoyi-common/ruoyi-common-log/pom.xml ./ruoyi-common/ruoyi-common-log/
COPY ruoyi-common/ruoyi-common-mail/pom.xml ./ruoyi-common/ruoyi-common-mail/
COPY ruoyi-common/ruoyi-common-mybatis/pom.xml ./ruoyi-common/ruoyi-common-mybatis/
COPY ruoyi-common/ruoyi-common-oss/pom.xml ./ruoyi-common/ruoyi-common-oss/
COPY ruoyi-common/ruoyi-common-ratelimiter/pom.xml ./ruoyi-common/ruoyi-common-ratelimiter/
COPY ruoyi-common/ruoyi-common-satoken/pom.xml ./ruoyi-common/ruoyi-common-satoken/
COPY ruoyi-common/ruoyi-common-security/pom.xml ./ruoyi-common/ruoyi-common-security/
COPY ruoyi-common/ruoyi-common-sensitive/pom.xml ./ruoyi-common/ruoyi-common-sensitive/
COPY ruoyi-common/ruoyi-common-sms/pom.xml ./ruoyi-common/ruoyi-common-sms/
COPY ruoyi-common/ruoyi-common-translation/pom.xml ./ruoyi-common/ruoyi-common-translation/
COPY ruoyi-common/ruoyi-common-web/pom.xml ./ruoyi-common/ruoyi-common-web/

# 复制 modules 子模块的 pom.xml
COPY ruoyi-modules/ruoyi-system/pom.xml ./ruoyi-modules/ruoyi-system/

# 下载依赖（利用 Docker 缓存，如果 pom.xml 没变就不会重新下载）
RUN mvn dependency:go-offline -B || true

# 复制所有源代码
COPY . .

# 构建项目（使用 prod profile，跳过测试）
RUN mvn clean package -DskipTests -Pprod -B

# ============================================
# 第二阶段：运行阶段（使用 JRE 运行应用）
# ============================================
FROM eclipse-temurin:17-jre-alpine

LABEL maintainer="wms"

# 设置工作目录
WORKDIR /app

# 创建日志和临时文件目录
RUN mkdir -p /app/logs /app/temp

# 设置时区
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata

# 从构建阶段复制 JAR 包
COPY --from=builder /build/ruoyi-admin-wms/target/*.jar app.jar

# 暴露端口
EXPOSE 8080

# JVM参数优化
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m -Djava.security.egd=file:/dev/./urandom"

# 启动应用（支持外部配置文件）
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar --spring.config.location=classpath:/application.yml,file:/app/config/application-prod.yml"]
