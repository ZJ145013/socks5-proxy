# 项目设置指南

## 📦 已添加的文件

本次复刻添加了以下自动化部署配置：

```
socks5-proxy/
├── .github/
│   └── workflows/
│       └── docker-build.yml      # GitHub Actions 自动构建配置
├── docker-compose.yml            # 生产环境部署配置
├── docker-compose.dev.yml        # 开发环境部署配置
├── .env.example                  # 环境变量模板
├── DEPLOY.md                     # 详细部署文档
├── SETUP.md                      # 本文件
├── .gitignore                    # 更新的忽略规则
└── README.md                     # 更新的说明文档
```

## 🚀 GitHub 仓库设置

### 1. 创建新仓库

```bash
# 在 GitHub 上创建新仓库（例如：yourusername/socks5-proxy）
# 然后在本地初始化

cd /path/to/socks5-proxy
git init
git add .
git commit -m "feat: add automated Docker build and compose deployment"
git branch -M main
git remote add origin https://github.com/yourusername/socks5-proxy.git
git push -u origin main
```

### 2. 启用 GitHub Container Registry

GitHub Container Registry (ghcr.io) 会自动启用，无需额外配置。

**验证步骤**：
1. 推送代码后，访问仓库的 **Actions** 标签页
2. 查看 "Build and Push Docker Image" 工作流是否运行
3. 构建成功后，访问仓库的 **Packages** 标签页
4. 应该能看到 `socks5-proxy` 镜像

### 3. 配置 Docker Hub（可选）

如果想同时推送到 Docker Hub：

#### 步骤 A：获取 Docker Hub Access Token

1. 访问 https://hub.docker.com/settings/security
2. 点击 **New Access Token**
3. 输入描述（如 "GitHub Actions"）
4. 选择权限：**Read, Write, Delete**
5. 点击 **Generate**
6. **复制并保存** token（只显示一次）

#### 步骤 B：添加 GitHub Secrets

1. 访问你的 GitHub 仓库
2. 进入 **Settings** → **Secrets and variables** → **Actions**
3. 点击 **New repository secret**
4. 添加以下两个 secrets：

   | Name | Value |
   |------|-------|
   | `DOCKERHUB_USERNAME` | 你的 Docker Hub 用户名 |
   | `DOCKERHUB_TOKEN` | 刚才生成的 Access Token |

### 4. 配置仓库权限

确保 GitHub Actions 有权限推送到 GHCR：

1. 进入仓库 **Settings** → **Actions** → **General**
2. 滚动到 **Workflow permissions**
3. 选择 **Read and write permissions**
4. 勾选 **Allow GitHub Actions to create and approve pull requests**
5. 点击 **Save**

## 🏷️ 触发自动构建

### 方式一：推送到 main 分支

```bash
git add .
git commit -m "update: some changes"
git push origin main
```

这会触发构建并生成以下标签：
- `latest`
- `main`

### 方式二：创建版本标签

```bash
# 创建版本标签
git tag v1.0.0
git push origin v1.0.0
```

这会生成以下标签：
- `v1.0.0`
- `v1.0`
- `v1`
- `latest`

### 方式三：Pull Request

创建 PR 时会触发构建测试，但不会推送镜像。

## 📥 使用构建的镜像

### 从 GitHub Container Registry 拉取

```bash
# 拉取最新版本
docker pull ghcr.io/yourusername/socks5-proxy:latest

# 拉取特定版本
docker pull ghcr.io/yourusername/socks5-proxy:v1.0.0
```

### 从 Docker Hub 拉取（如果配置了）

```bash
docker pull yourusername/socks5-pool:latest
```

## 🔧 本地测试

### 测试 Docker 构建

```bash
# 构建镜像
docker build -t socks5-pool:test .

# 运行测试
docker run --rm -p 1080:1080 -p 8080:8080 socks5-pool:test
```

### 测试 Docker Compose

```bash
# 开发环境（本地构建）
docker-compose -f docker-compose.dev.yml up -d

# 查看日志
docker-compose -f docker-compose.dev.yml logs -f

# 停止
docker-compose -f docker-compose.dev.yml down
```

### 测试生产配置

```bash
# 修改 .env 文件中的 GITHUB_REPOSITORY
cp .env.example .env
nano .env  # 修改为你的仓库名

# 启动
docker-compose up -d

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

## 🌐 访问服务

启动后访问：
- **SOCKS5 代理**: `socks5://localhost:1080`
- **Web 面板**: http://localhost:8080
- **API 状态**: http://localhost:8080/api/status

## 🔍 验证部署

### 检查容器状态

```bash
docker ps
```

应该看到类似输出：
```
CONTAINER ID   IMAGE                                    STATUS         PORTS
abc123def456   ghcr.io/yourusername/socks5-proxy:latest Up 2 minutes   0.0.0.0:1080->1080/tcp, 0.0.0.0:8080->8080/tcp
```

### 测试 SOCKS5 代理

```bash
# 使用 curl 测试
curl -x socks5://localhost:1080 https://api.ipify.org?format=json

# 应该返回代理的 IP 地址
```

### 测试 Web 面板

```bash
# 获取状态
curl http://localhost:8080/api/status

# 应该返回 JSON 格式的代理池状态
```

## 📊 监控构建状态

### GitHub Actions

1. 访问仓库的 **Actions** 标签页
2. 查看最近的工作流运行
3. 点击具体的运行查看详细日志

### 构建徽章（可选）

在 README.md 中添加构建状态徽章：

```markdown
![Docker Build](https://github.com/yourusername/socks5-proxy/actions/workflows/docker-build.yml/badge.svg)
```

## 🛠️ 故障排查

### 构建失败

**问题**：GitHub Actions 构建失败

**解决方案**：
1. 检查 Actions 日志中的错误信息
2. 确认 Dockerfile 语法正确
3. 验证 workflow 文件格式

### 推送失败

**问题**：无法推送到 GHCR 或 Docker Hub

**解决方案**：
1. 检查仓库权限设置（Read and write permissions）
2. 验证 Docker Hub secrets 是否正确配置
3. 确认 token 没有过期

### 镜像拉取失败

**问题**：无法拉取镜像

**解决方案**：
1. 确认镜像已成功构建并推送
2. 检查镜像名称和标签是否正确
3. 对于私有仓库，需要先登录：
   ```bash
   echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
   ```

### 容器启动失败

**问题**：Docker Compose 启动失败

**解决方案**：
1. 检查端口是否被占用：`netstat -tuln | grep -E '1080|8080'`
2. 查看容器日志：`docker-compose logs`
3. 验证 .env 文件配置

## 🔄 更新流程

### 更新代码

```bash
# 修改代码
git add .
git commit -m "feat: add new feature"
git push origin main

# 等待自动构建完成（约 2-5 分钟）
```

### 更新部署

```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose up -d

# 验证更新
docker-compose ps
docker-compose logs --tail=50
```

## 📝 最佳实践

1. **版本管理**
   - 使用语义化版本号（v1.0.0, v1.1.0, v2.0.0）
   - 重大更新使用主版本号
   - 功能添加使用次版本号
   - Bug 修复使用修订版本号

2. **安全性**
   - 定期更新基础镜像
   - 不要在代码中硬编码敏感信息
   - 使用 GitHub Secrets 管理凭证
   - 定期轮换 Access Tokens

3. **监控**
   - 定期检查 Actions 运行状态
   - 监控镜像大小变化
   - 关注安全漏洞扫描结果

4. **文档**
   - 保持 README.md 和 DEPLOY.md 更新
   - 记录重要的配置变更
   - 在 CHANGELOG.md 中记录版本变化

## 🎯 下一步

- [ ] 推送代码到 GitHub
- [ ] 配置 GitHub Actions 权限
- [ ] （可选）配置 Docker Hub secrets
- [ ] 验证自动构建成功
- [ ] 测试镜像拉取和部署
- [ ] 更新 README.md 中的仓库链接
- [ ] 添加构建状态徽章

## 📚 相关文档

- [DEPLOY.md](DEPLOY.md) - 详细部署指南
- [README.md](README.md) - 项目说明
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Docker Compose 文档](https://docs.docker.com/compose/)
- [GHCR 文档](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
