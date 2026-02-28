# socks5-pool

自动轮换的 SOCKS5 代理池。从公开源抓取免费 SOCKS5 代理，验证 Google 连通性，过滤中国大陆/香港 IP，提供本地 SOCKS5 端点并自动轮换上游代理。

<img width="1910" height="915" alt="image" src="https://github.com/user-attachments/assets/c17a03a8-ec93-4c8c-b2fa-58e23c62a729" />

## 功能特性

- 从可配置源抓取代理列表（默认：`socks5-proxy.github.io`）
- 并发健康检查，验证 Google 连通性
- 自动过滤中国大陆和香港代理
- 每 3-6 分钟随机自动轮换 IP
- 每 20 分钟刷新代理池（池为空时自动刷新）
- 自动故障转移：连接失败时切换代理（最多重试 3 次）
- Web 管理面板，支持手动切换和刷新
- 零外部依赖（仅使用 Go 标准库）

## 快速开始

```bash
# 构建
go build -o socks5-pool .

# 使用默认配置运行（SOCKS5 端口 :1080，面板端口 :8080）
./socks5-pool

# 自定义配置
./socks5-pool -listen 127.0.0.1:1080 -status 127.0.0.1:8080 -scrape-interval 15m
```

## 命令行参数

| 参数 | 默认值 | 说明 |
|------|---------|-------------|
| `-listen` | `127.0.0.1:1080` | SOCKS5 监听地址 |
| `-status` | `127.0.0.1:8080` | HTTP 面板地址 |
| `-url` | `https://socks5-proxy.github.io/` | 代理列表源 URL |
| `-scrape-interval` | `20m` | 代理池刷新间隔 |
| `-check-timeout` | `10s` | 单个代理健康检查超时 |
| `-max-concurrent` | `20` | 最大并发健康检查数 |

## Web 管理面板

访问 `http://localhost:8080` 打开 Web 管理面板：

- 查看所有代理及其国家/城市信息
- 查看当前活跃代理
- 点击任意代理手动切换
- 触发手动刷新代理池

### API 接口

```
GET  /api/status           # 获取代理池状态（JSON）
POST /api/refresh          # 触发代理池刷新
GET  /api/switch           # 切换到下一个代理
GET  /api/switch?index=N   # 切换到指定索引的代理
```

## 部署方式

### Docker Compose（推荐）

```bash
# 克隆仓库
git clone https://github.com/ZJ145013/socks5-proxy.git
cd socks5-proxy

# 复制环境变量文件
cp .env.example .env

# 使用 Docker Compose 启动
docker-compose up -d

# 查看日志
docker-compose logs -f
```

### Docker

```bash
# 使用 GitHub Container Registry 的预构建镜像
docker pull ghcr.io/ZJ145013/socks5-proxy:latest
docker run -d -p 1080:1080 -p 8080:8080 ghcr.io/ZJ145013/socks5-proxy:latest

# 或本地构建
docker build -t socks5-pool .
docker run -p 1080:1080 -p 8080:8080 socks5-pool
```

### Railway

项目包含 `railway.toml` 配置文件，支持一键部署到 Railway。

📖 **详细部署说明请查看 [DEPLOY.md](DEPLOY.md)**

## 项目结构

```
├── main.go        # 程序入口，刷新和轮换循环
├── config.go      # 命令行参数解析
├── server.go      # SOCKS5 协议实现
├── pool.go        # 代理池管理
├── scraper.go     # 代理列表抓取
├── checker.go     # 健康检查和地理位置查询
├── status.go      # Web 面板和 API
├── Dockerfile     # 多阶段 Docker 构建
└── railway.toml   # Railway 部署配置
```

## 自动化构建

本项目配置了 GitHub Actions 自动构建：

- ✅ 推送到 main 分支自动构建
- ✅ 创建版本标签自动构建
- ✅ 多架构支持（amd64 + arm64）
- ✅ 自动推送到 GitHub Container Registry

查看构建状态：https://github.com/ZJ145013/socks5-proxy/actions

## 使用说明

### 访问服务

- **SOCKS5 代理**：`socks5://localhost:1080`
- **Web 管理面板**：http://localhost:8080

### 测试代理

```bash
# 使用 curl 测试
curl -x socks5://localhost:1080 https://api.ipify.org?format=json

# 应该返回代理的 IP 地址
```

## ⚠️ 安全提示

- 本项目使用免费公开代理，**不适合传输敏感数据**
- 仅建议在受信任的网络环境中使用
- 不要通过代理传输密码、密钥等敏感信息
- 代理质量和可用性无法保证

## 许可证

本项目基于原项目 [Dreamy-rain/socks5-proxy](https://github.com/Dreamy-rain/socks5-proxy) 进行 Fork 和增强。

## 贡献

欢迎提交 Issue 和 Pull Request！
