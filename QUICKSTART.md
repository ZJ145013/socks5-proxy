# 快速开始指南

## ✅ 已完成的配置

本项目已添加完整的自动化部署配置，包括：

### 📁 新增文件

```
✓ .github/workflows/docker-build.yml  # GitHub Actions 自动构建
✓ docker-compose.yml                  # 生产环境部署
✓ docker-compose.dev.yml              # 开发环境部署
✓ .env.example                        # 环境变量模板
✓ DEPLOY.md                           # 详细部署文档
✓ SETUP.md                            # 仓库设置指南
✓ QUICKSTART.md                       # 本文件
```

### 📝 更新文件

```
✓ README.md                           # 添加部署说明
✓ .gitignore                          # 更新忽略规则
```

## 🚀 三步快速部署

### 方式一：使用 Docker Compose（推荐）

```bash
# 1. 克隆或进入项目目录
cd socks5-proxy

# 2. 复制环境变量文件
cp .env.example .env

# 3. 启动服务
docker-compose -f docker-compose.dev.yml up -d

# 查看日志
docker-compose -f docker-compose.dev.yml logs -f
```

**访问服务**：
- SOCKS5 代理: `socks5://localhost:1080`
- Web 面板: http://localhost:8080

### 方式二：直接使用 Docker

```bash
# 构建镜像
docker build -t socks5-pool .

# 运行容器
docker run -d \
  --name socks5-pool \
  -p 1080:1080 \
  -p 8080:8080 \
  socks5-pool

# 查看日志
docker logs -f socks5-pool
```

### 方式三：本地运行（开发）

```bash
# 构建
go build -o socks5-pool .

# 运行
./socks5-pool

# 或使用自定义配置
./socks5-pool -listen 127.0.0.1:1080 -status 127.0.0.1:8080
```

## 🔧 GitHub 仓库设置（自动构建）

### 1. 推送到 GitHub

```bash
# 初始化 Git（如果还没有）
git init
git add .
git commit -m "feat: add automated Docker build and compose deployment"

# 添加远程仓库
git remote add origin https://github.com/yourusername/socks5-proxy.git
git branch -M main
git push -u origin main
```

### 2. 配置仓库权限

1. 进入 GitHub 仓库 **Settings** → **Actions** → **General**
2. 在 **Workflow permissions** 选择：
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**
3. 点击 **Save**

### 3. 触发自动构建

```bash
# 推送代码会自动触发构建
git push origin main

# 或创建版本标签
git tag v1.0.0
git push origin v1.0.0
```

### 4. 查看构建结果

1. 访问仓库的 **Actions** 标签页
2. 查看 "Build and Push Docker Image" 工作流
3. 构建成功后，在 **Packages** 标签页可以看到镜像

## 📦 使用自动构建的镜像

构建成功后，可以直接使用：

```bash
# 拉取镜像
docker pull ghcr.io/yourusername/socks5-proxy:latest

# 运行
docker run -d -p 1080:1080 -p 8080:8080 ghcr.io/yourusername/socks5-proxy:latest
```

或更新 `docker-compose.yml` 中的镜像地址：

```yaml
services:
  socks5-pool:
    image: ghcr.io/yourusername/socks5-proxy:latest
    # ...
```

## 🎯 可选配置

### 配置 Docker Hub（可选）

如果想同时推送到 Docker Hub：

1. 获取 Docker Hub Access Token：https://hub.docker.com/settings/security
2. 在 GitHub 仓库添加 Secrets：
   - `DOCKERHUB_USERNAME`: Docker Hub 用户名
   - `DOCKERHUB_TOKEN`: Access Token

### 自定义配置

编辑 `docker-compose.yml` 中的参数：

```yaml
command: >
  ./socks5-pool
  -listen 0.0.0.0:1080
  -status 0.0.0.0:8080
  -scrape-interval 15m      # 改为 15 分钟刷新
  -check-timeout 5s         # 改为 5 秒超时
  -max-concurrent 50        # 增加并发数
```

## 🧪 测试部署

### 测试 SOCKS5 代理

```bash
# 使用 curl 测试
curl -x socks5://localhost:1080 https://api.ipify.org?format=json

# 应该返回代理的 IP 地址
```

### 测试 Web API

```bash
# 获取状态
curl http://localhost:8080/api/status

# 手动刷新代理池
curl -X POST http://localhost:8080/api/refresh

# 切换代理
curl http://localhost:8080/api/switch
```

### 查看容器状态

```bash
# 查看运行状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 查看资源使用
docker stats socks5-pool
```

## 🛠️ 常用命令

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看日志
docker-compose logs -f

# 更新镜像
docker-compose pull
docker-compose up -d

# 清理
docker-compose down -v
docker system prune -f
```

## 📚 详细文档

- **[SETUP.md](SETUP.md)** - GitHub 仓库设置和自动构建配置
- **[DEPLOY.md](DEPLOY.md)** - 完整的部署指南和故障排查
- **[README.md](README.md)** - 项目说明和功能介绍

## ⚠️ 注意事项

1. **安全性**：此项目使用免费公开代理，不适合传输敏感数据
2. **端口占用**：确保 1080 和 8080 端口未被占用
3. **网络连接**：需要能访问 `socks5-proxy.github.io` 和 `ip-api.com`
4. **资源使用**：默认并发检查 20 个代理，可根据需要调整

## 🎉 完成！

现在你可以：
- ✅ 本地运行和测试
- ✅ 推送到 GitHub 触发自动构建
- ✅ 使用 Docker Compose 一键部署
- ✅ 通过 Web 面板管理代理池

有问题？查看 [DEPLOY.md](DEPLOY.md) 获取详细帮助。
