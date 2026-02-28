# 部署指南

## 🚀 快速部署

### 方式一：Docker Compose（推荐）

#### 1. 使用预构建镜像

```bash
# 克隆仓库
git clone https://github.com/yourusername/socks5-proxy.git
cd socks5-proxy

# 复制环境变量文件
cp .env.example .env

# 编辑 .env 文件，设置你的 GitHub 用户名
nano .env

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

#### 2. 本地构建部署

```bash
# 使用开发配置（本地构建）
docker-compose -f docker-compose.dev.yml up -d

# 查看日志
docker-compose -f docker-compose.dev.yml logs -f
```

### 方式二：直接使用 Docker

```bash
# 拉取镜像
docker pull ghcr.io/yourusername/socks5-proxy:latest

# 运行容器
docker run -d \
  --name socks5-pool \
  --restart unless-stopped \
  -p 1080:1080 \
  -p 8080:8080 \
  ghcr.io/yourusername/socks5-proxy:latest

# 查看日志
docker logs -f socks5-pool
```

### 方式三：从源码构建

```bash
# 构建镜像
docker build -t socks5-pool:local .

# 运行
docker run -d \
  --name socks5-pool \
  -p 1080:1080 \
  -p 8080:8080 \
  socks5-pool:local
```

## 📦 自动化构建配置

### GitHub Actions 设置

项目已配置自动化 CI/CD，每次推送到 `main` 分支或创建 tag 时会自动构建并推送镜像。

#### 配置步骤：

1. **启用 GitHub Container Registry**
   - 无需额外配置，使用 `GITHUB_TOKEN` 自动推送到 `ghcr.io`

2. **配置 Docker Hub（可选）**

   在 GitHub 仓库设置中添加 Secrets：
   - `DOCKERHUB_USERNAME`: 你的 Docker Hub 用户名
   - `DOCKERHUB_TOKEN`: Docker Hub Access Token

   获取 Docker Hub Token：
   ```bash
   # 访问 https://hub.docker.com/settings/security
   # 创建 New Access Token
   ```

3. **触发构建**
   ```bash
   # 推送代码触发构建
   git push origin main

   # 或创建版本标签
   git tag v1.0.0
   git push origin v1.0.0
   ```

4. **查看构建状态**
   - 访问仓库的 Actions 标签页
   - 查看 "Build and Push Docker Image" 工作流

### 镜像标签说明

自动构建会生成以下标签：

- `latest` - 最新的 main 分支构建
- `main` - main 分支构建
- `v1.0.0` - 版本标签（如果推送 tag）
- `v1.0` - 次版本号
- `v1` - 主版本号

## 🔧 配置选项

### 环境变量

在 `docker-compose.yml` 中可以通过 command 参数调整：

```yaml
command: >
  ./socks5-pool
  -listen 0.0.0.0:1080          # SOCKS5 监听地址
  -status 0.0.0.0:8080          # 状态面板地址
  -url https://socks5-proxy.github.io/  # 代理源 URL
  -scrape-interval 20m          # 抓取间隔
  -check-timeout 10s            # 检查超时
  -max-concurrent 20            # 最大并发检查数
```

### 自定义端口

编辑 `docker-compose.yml`：

```yaml
ports:
  - "2080:1080"  # 将本地 2080 映射到容器 1080
  - "9090:8080"  # 将本地 9090 映射到容器 8080
```

## 🌐 访问服务

- **SOCKS5 代理**: `socks5://localhost:1080`
- **Web 面板**: `http://localhost:8080`
- **API 状态**: `http://localhost:8080/api/status`

## 🔍 健康检查

```bash
# 检查容器状态
docker ps

# 检查健康状态
docker inspect socks5-pool | grep -A 10 Health

# API 健康检查
curl http://localhost:8080/api/status
```

## 📊 监控和日志

```bash
# 实时日志
docker-compose logs -f

# 查看最近 100 行
docker-compose logs --tail=100

# 查看特定时间段
docker-compose logs --since 30m
```

## 🛠️ 故障排查

### 容器无法启动

```bash
# 查看详细日志
docker logs socks5-pool

# 检查端口占用
netstat -tuln | grep -E '1080|8080'

# 重新构建
docker-compose down
docker-compose up -d --build
```

### 代理池为空

- 检查网络连接
- 查看日志中的抓取错误
- 手动触发刷新：访问 `http://localhost:8080` 点击 "Refresh Pool"

### 性能优化

```yaml
# 增加并发检查数
command: >
  ./socks5-pool
  -max-concurrent 50
  -check-timeout 5s
```

## 🔄 更新镜像

```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose up -d

# 清理旧镜像
docker image prune -f
```

## 🗑️ 完全卸载

```bash
# 停止并删除容器
docker-compose down

# 删除镜像
docker rmi ghcr.io/yourusername/socks5-proxy:latest

# 删除网络
docker network rm socks5-network
```

## 📝 生产环境建议

1. **使用反向代理**（Nginx/Traefik）保护状态面板
2. **配置防火墙**限制 SOCKS5 端口访问
3. **启用日志轮转**避免磁盘占满
4. **监控代理池状态**设置告警
5. **定期更新镜像**获取安全补丁

## 🔐 安全提示

⚠️ **重要**：此项目使用免费公开代理，不适合传输敏感数据。

- 仅在受信任的网络环境中使用
- 不要通过代理传输密码、密钥等敏感信息
- 建议配合 VPN 或其他加密方案使用
- 生产环境建议添加认证机制
