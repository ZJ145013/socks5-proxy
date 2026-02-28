#!/bin/bash
# 自动化复刻脚本 - ZJ145013/socks5-proxy
# 使用方法: bash setup.sh

set -e

echo "🚀 socks5-proxy 项目复刻脚本"
echo "================================"
echo ""
echo "GitHub 用户名: ZJ145013"
echo "仓库名称: socks5-proxy"
echo ""

# 检查是否在正确的目录
if [ ! -f "main.go" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi

echo "✓ 项目目录检查通过"
echo ""

# 检查 Git
if ! command -v git &> /dev/null; then
    echo "❌ 错误: 未安装 Git"
    exit 1
fi

echo "✓ Git 环境检查通过"
echo ""

# 步骤 1: 初始化 Git 仓库
echo "📦 步骤 1/4: 初始化 Git 仓库..."
if [ -d ".git" ]; then
    echo "⚠️  Git 仓库已存在，跳过初始化"
else
    git init
    echo "✓ Git 仓库初始化完成"
fi
echo ""

# 步骤 2: 添加所有文件
echo "📦 步骤 2/4: 添加项目文件..."
git add .
echo "✓ 文件添加完成"
echo ""

# 步骤 3: 创建提交
echo "📦 步骤 3/4: 创建提交..."
if git rev-parse HEAD >/dev/null 2>&1; then
    echo "⚠️  已存在提交，跳过"
else
    git commit -m "feat: add automated Docker build and compose deployment

- Add GitHub Actions workflow for multi-arch Docker builds
- Add Docker Compose configurations for prod and dev
- Add comprehensive deployment documentation
- Configure for ZJ145013/socks5-proxy
- Add automated setup and deployment scripts"
    echo "✓ 提交创建完成"
fi
echo ""

# 步骤 4: 配置远程仓库
echo "📦 步骤 4/4: 配置远程仓库..."
if git remote | grep -q "origin"; then
    echo "⚠️  远程仓库已存在"
    echo "当前远程地址: $(git remote get-url origin)"
    read -p "是否更新为 https://github.com/ZJ145013/socks5-proxy.git? [y/N]: " update_remote
    if [ "$update_remote" = "y" ] || [ "$update_remote" = "Y" ]; then
        git remote set-url origin https://github.com/ZJ145013/socks5-proxy.git
        echo "✓ 远程仓库地址已更新"
    fi
else
    git remote add origin https://github.com/ZJ145013/socks5-proxy.git
    echo "✓ 远程仓库配置完成"
fi
echo ""

# 设置主分支
git branch -M main
echo "✓ 主分支设置为 main"
echo ""

echo "================================"
echo "✅ 本地配置完成！"
echo ""
echo "📤 下一步: 推送到 GitHub"
echo ""
echo "请确保你已经在 GitHub 上创建了仓库:"
echo "👉 https://github.com/ZJ145013/socks5-proxy"
echo ""
echo "如果还没有创建，请访问:"
echo "👉 https://github.com/new"
echo "   - 仓库名: socks5-proxy"
echo "   - 可见性: Public 或 Private"
echo "   - 不要初始化 README、.gitignore 或 license"
echo ""
read -p "仓库已创建？按回车继续推送，或 Ctrl+C 取消: "
echo ""

# 推送到 GitHub
echo "📤 推送代码到 GitHub..."
if git push -u origin main; then
    echo ""
    echo "================================"
    echo "🎉 代码推送成功！"
    echo ""
    echo "📊 查看你的仓库:"
    echo "👉 https://github.com/ZJ145013/socks5-proxy"
    echo ""
    echo "⚙️  下一步: 配置 GitHub Actions"
    echo ""
    echo "1. 访问设置页面:"
    echo "   👉 https://github.com/ZJ145013/socks5-proxy/settings/actions"
    echo ""
    echo "2. 滚动到 'Workflow permissions'"
    echo "   ✅ 选择 'Read and write permissions'"
    echo "   ✅ 勾选 'Allow GitHub Actions to create and approve pull requests'"
    echo "   点击 'Save'"
    echo ""
    echo "3. 查看自动构建:"
    echo "   👉 https://github.com/ZJ145013/socks5-proxy/actions"
    echo "   等待 2-5 分钟构建完成"
    echo ""
    echo "4. 查看构建的镜像:"
    echo "   👉 https://github.com/ZJ145013/socks5-proxy/pkgs/container/socks5-proxy"
    echo ""
    echo "📦 使用镜像:"
    echo "   docker pull ghcr.io/ZJ145013/socks5-proxy:latest"
    echo ""
    echo "🚀 本地部署:"
    echo "   bash deploy.sh"
    echo ""
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "可能的原因:"
    echo "1. 仓库不存在 - 请先在 GitHub 创建仓库"
    echo "2. 没有权限 - 请检查 Git 认证配置"
    echo "3. 网络问题 - 请检查网络连接"
    echo ""
    echo "手动推送命令:"
    echo "git push -u origin main"
    exit 1
fi
