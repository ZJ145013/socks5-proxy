#!/bin/bash
# 一键部署脚本 - ZJ145013/socks5-proxy

set -e

echo "🚀 socks5-proxy 一键部署脚本"
echo "================================"
echo ""

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "❌ 错误: 未安装 Docker"
    echo "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查 Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ 错误: 未安装 Docker Compose"
    echo "请先安装 Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✓ Docker 环境检查通过"
echo ""

# 选择部署模式
echo "请选择部署模式:"
echo "1) 开发环境（本地构建）"
echo "2) 生产环境（使用预构建镜像）"
read -p "请输入选项 [1/2]: " mode

case $mode in
    1)
        echo ""
        echo "📦 启动开发环境..."
        docker-compose -f docker-compose.dev.yml up -d
        compose_file="docker-compose.dev.yml"
        ;;
    2)
        echo ""
        echo "📦 启动生产环境..."
        if [ ! -f .env ]; then
            echo "⚠️  未找到 .env 文件，使用默认配置"
            cp .env.example .env
        fi
        docker-compose up -d
        compose_file="docker-compose.yml"
        ;;
    *)
        echo "❌ 无效选项"
        exit 1
        ;;
esac

echo ""
echo "⏳ 等待容器启动..."
sleep 5

# 检查容器状态
if docker-compose -f $compose_file ps | grep -q "Up"; then
    echo ""
    echo "✅ 部署成功！"
    echo ""
    echo "📊 服务信息:"
    echo "  - SOCKS5 代理: socks5://localhost:1080"
    echo "  - Web 面板: http://localhost:8080"
    echo "  - API 状态: http://localhost:8080/api/status"
    echo ""
    echo "📝 常用命令:"
    echo "  - 查看日志: docker-compose -f $compose_file logs -f"
    echo "  - 查看状态: docker-compose -f $compose_file ps"
    echo "  - 停止服务: docker-compose -f $compose_file down"
    echo ""
    echo "🧪 测试命令:"
    echo "  curl http://localhost:8080/api/status"
    echo "  curl -x socks5://localhost:1080 https://api.ipify.org?format=json"
else
    echo ""
    echo "❌ 部署失败，请查看日志:"
    docker-compose -f $compose_file logs
    exit 1
fi
