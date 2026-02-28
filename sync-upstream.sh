#!/bin/bash
# 同步上游仓库更新

cd /c/Users/19166/Desktop/projects/socks5-proxy

echo "🔄 同步上游仓库更新"
echo "================================"
echo ""

# 添加上游仓库（如果还没有）
if ! git remote | grep -q "upstream"; then
    echo "📌 添加上游仓库..."
    git remote add upstream https://github.com/Dreamy-rain/socks5-proxy.git
    echo "✓ 上游仓库已添加"
else
    echo "✓ 上游仓库已存在"
fi
echo ""

# 获取上游更新
echo "📥 获取上游更新..."
git fetch upstream
echo ""

# 显示差异
echo "📊 检查更新..."
BEHIND=$(git rev-list --count HEAD..upstream/main)
if [ "$BEHIND" -eq 0 ]; then
    echo "✓ 已是最新，无需同步"
    exit 0
fi

echo "⚠️  发现 $BEHIND 个新提交"
echo ""
echo "最新的提交："
git log --oneline HEAD..upstream/main | head -5
echo ""

read -p "是否合并这些更新？[y/N]: " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "❌ 已取消"
    exit 0
fi

# 合并更新
echo ""
echo "🔀 合并上游更新..."
git merge upstream/main

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ 合并成功"
    echo ""
    read -p "是否推送到你的仓库？[y/N]: " push_confirm
    if [ "$push_confirm" = "y" ] || [ "$push_confirm" = "Y" ]; then
        git push origin main
        echo ""
        echo "================================"
        echo "✅ 同步完成！"
        echo ""
        echo "你的仓库已更新："
        echo "https://github.com/ZJ145013/socks5-proxy"
    fi
else
    echo ""
    echo "❌ 合并冲突"
    echo ""
    echo "请手动解决冲突："
    echo "1. 编辑冲突文件"
    echo "2. git add <文件>"
    echo "3. git commit"
    echo "4. git push origin main"
fi
