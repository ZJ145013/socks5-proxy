# 🚀 一键复刻指南

## 方式一：使用自动化脚本（推荐）

```bash
# 进入项目目录
cd /c/Users/19166/Desktop/projects/socks5-proxy

# 运行自动化脚本
bash setup.sh
```

脚本会自动完成：
- ✅ Git 初始化
- ✅ 添加所有文件
- ✅ 创建提交
- ✅ 配置远程仓库
- ✅ 推送到 GitHub

---

## 方式二：手动执行（逐步操作）

### 第一步：在 GitHub 创建仓库

1. 访问 https://github.com/new
2. 填写信息：
   - **Repository name**: `socks5-proxy`
   - **Description**: `A self-rotating SOCKS5 proxy pool`
   - **Visibility**: Public 或 Private
   - ⚠️ **不要**勾选 "Initialize this repository with a README"
3. 点击 **Create repository**

### 第二步：推送代码

```bash
cd /c/Users/19166/Desktop/projects/socks5-proxy

# 初始化 Git
git init

# 添加所有文件
git add .

# 创建提交
git commit -m "feat: add automated Docker build and compose deployment"

# 添加远程仓库
git remote add origin https://github.com/ZJ145013/socks5-proxy.git

# 设置主分支
git branch -M main

# 推送代码
git push -u origin main
```

### 第三步：配置 GitHub Actions

1. 访问 https://github.com/ZJ145013/socks5-proxy/settings/actions
2. 滚动到 **Workflow permissions**
3. 选择：
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**
4. 点击 **Save**

### 第四步：查看构建

1. 访问 https://github.com/ZJ145013/socks5-proxy/actions
2. 等待构建完成（约 2-5 分钟）
3. 查看镜像：https://github.com/ZJ145013/socks5-proxy/pkgs/container/socks5-proxy

---

## 验证部署

### 拉取并运行镜像

```bash
# 拉取镜像
docker pull ghcr.io/ZJ145013/socks5-proxy:latest

# 运行
docker run -d -p 1080:1080 -p 8080:8080 ghcr.io/ZJ145013/socks5-proxy:latest

# 或使用 Docker Compose
docker-compose up -d
```

### 测试服务

```bash
# 测试 API
curl http://localhost:8080/api/status

# 测试代理
curl -x socks5://localhost:1080 https://api.ipify.org?format=json
```

### 访问服务

- **SOCKS5 代理**: `socks5://localhost:1080`
- **Web 面板**: http://localhost:8080

---

## 常见问题

### Q: 推送失败 "remote: Repository not found"

**解决方案**：
1. 确认已在 GitHub 创建仓库
2. 检查仓库名称是否正确
3. 确认 Git 认证配置正确

```bash
# 检查远程地址
git remote -v

# 如果地址错误，更新
git remote set-url origin https://github.com/ZJ145013/socks5-proxy.git
```

### Q: 推送失败 "Authentication failed"

**解决方案**：
1. 使用 Personal Access Token (PAT)
2. 访问 https://github.com/settings/tokens
3. 生成新 token（勾选 repo 权限）
4. 使用 token 作为密码

```bash
# 推送时输入
Username: ZJ145013
Password: <你的 Personal Access Token>
```

### Q: GitHub Actions 构建失败

**解决方案**：
1. 检查 Actions 权限配置
2. 查看 Actions 日志中的错误
3. 确认 Dockerfile 语法正确

---

## 快速命令参考

```bash
# 查看 Git 状态
git status

# 查看远程仓库
git remote -v

# 查看提交历史
git log --oneline

# 创建版本标签
git tag v1.0.0
git push origin v1.0.0

# 查看本地分支
git branch

# 查看远程分支
git branch -r
```

---

## 项目链接

- **仓库**: https://github.com/ZJ145013/socks5-proxy
- **Actions**: https://github.com/ZJ145013/socks5-proxy/actions
- **Packages**: https://github.com/ZJ145013/socks5-proxy/pkgs/container/socks5-proxy
- **镜像**: `ghcr.io/ZJ145013/socks5-proxy:latest`

---

## 下一步

复刻完成后：

1. ⭐ **Star 你的仓库**
2. 📝 **编辑 README.md** 添加个性化说明
3. 🏷️ **创建第一个版本** `git tag v1.0.0 && git push origin v1.0.0`
4. 🚀 **部署测试** `bash deploy.sh`
5. 📊 **监控构建** 查看 Actions 页面

---

**选择你喜欢的方式开始复刻吧！** 🎉
