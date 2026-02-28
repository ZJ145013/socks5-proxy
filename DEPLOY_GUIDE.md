# 快速部署指南 - ZJ145013/socks5-proxy

## 🚀 一键部署（推荐）

```bash
# 1. 确保在项目目录
cd /c/Users/19166/Desktop/projects/socks5-proxy

# 2. 启动开发环境（本地构建）
docker-compose -f docker-compose.dev.yml up -d

# 3. 查看日志
docker-compose -f docker-compose.dev.yml logs -f
```

**访问服务**：
- SOCKS5 代理: `socks5://localhost:1080`
- Web 面板: http://localhost:8080

## 📤 推送到 GitHub

```bash
# 1. 初始化 Git（如果还没有）
git init
git add .
git commit -m "feat: add automated Docker build and compose deployment"

# 2. 添加远程仓库
git remote add origin https://github.com/ZJ145013/socks5-proxy.git
git branch -M main

# 3. 推送代码
git push -u origin main
```

## ⚙️ 配置 GitHub Actions

### 必需步骤（启用自动构建）

1. 访问 https://github.com/ZJ145013/socks5-proxy/settings/actions
2. 滚动到 **Workflow permissions**
3. 选择：
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**
4. 点击 **Save**

### 可选步骤（推送到 Docker Hub）

如果想同时推送到 Docker Hub：

1. 获取 Docker Hub Token：https://hub.docker.com/settings/security
2. 在 GitHub 添加 Secrets：
   - 访问 https://github.com/ZJ145013/socks5-proxy/settings/secrets/actions
   - 添加 `DOCKERHUB_USERNAME`: `ZJ145013`
   - 添加 `DOCKERHUB_TOKEN`: `你的token`

## 🎯 触发自动构建

```bash
# 方式一：推送代码（已在上面完成）
# 构建会自动开始

# 方式二：创建版本标签
git tag v1.0.0
git push origin v1.0.0
```

## 📦 使用构建的镜像

构建完成后（约 2-5 分钟）：

```bash
# 拉取镜像
docker pull ghcr.io/ZJ145013/socks5-proxy:latest

# 使用 Docker Compose 部署
docker-compose up -d

# 查看状态
docker-compose ps
docker-compose logs -f
```

## 🔍 验证部署

```bash
# 测试 Web API
curl http://localhost:8080/api/status

# 测试 SOCKS5 代理
curl -x socks5://localhost:1080 https://api.ipify.org?format=json

# 查看容器状态
docker ps | grep socks5
```

## 📊 查看构建状态

- **Actions**: https://github.com/ZJ145013/socks5-proxy/actions
- **Packages**: https://github.com/ZJ145013/socks5-proxy/pkgs/container/socks5-proxy

## 🛠️ 常用命令

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 查看日志
docker-compose logs -f

# 重启服务
docker-compose restart

# 更新镜像
docker-compose pull && docker-compose up -d
```

## 📚 详细文档

- [NEXT_STEPS.md](NEXT_STEPS.md) - 完整的下一步操作指南
- [SETUP.md](SETUP.md) - GitHub 仓库详细设置
- [DEPLOY.md](DEPLOY.md) - 部署文档和故障排查

## ✨ 项目链接

- **仓库**: https://github.com/ZJ145013/socks5-proxy
- **镜像**: ghcr.io/ZJ145013/socks5-proxy:latest
- **Actions**: https://github.com/ZJ145013/socks5-proxy/actions

---

**所有配置已使用你的 GitHub 用户名 `ZJ145013` 更新完成！** 🎉
