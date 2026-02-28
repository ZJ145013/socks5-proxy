# socks5-pool

A self-rotating SOCKS5 proxy pool. Scrapes free SOCKS5 proxies, verifies Google connectivity, filters out CN/HK IPs, and exposes a local SOCKS5 endpoint that automatically rotates upstream proxies.

<img width="1910" height="915" alt="image" src="https://github.com/user-attachments/assets/c17a03a8-ec93-4c8c-b2fa-58e23c62a729" />

## Features

- Scrapes proxy lists from configurable source (default: `socks5-proxy.github.io`)
- Concurrent health checks with Google connectivity verification
- Auto-filters China/Hong Kong proxies
- IP auto-rotation every 3-6 minutes (random)
- Pool refresh every 20 minutes (auto-refresh if pool is empty)
- Auto-failover: switches proxy on connection failure (up to 3 retries)
- Web dashboard with manual switch/refresh controls
- Zero external dependencies (Go stdlib only)

## Quick Start

```bash
# Build
go build -o socks5-pool .

# Run with defaults (SOCKS5 on :1080, dashboard on :8080)
./socks5-pool

# Custom config
./socks5-pool -listen 127.0.0.1:1080 -status 127.0.0.1:8080 -scrape-interval 15m
```

## CLI Flags

| Flag | Default | Description |
|------|---------|-------------|
| `-listen` | `127.0.0.1:1080` | SOCKS5 listen address |
| `-status` | `127.0.0.1:8080` | HTTP dashboard address |
| `-url` | `https://socks5-proxy.github.io/` | Proxy list source URL |
| `-scrape-interval` | `20m` | Pool refresh interval |
| `-check-timeout` | `10s` | Per-proxy health check timeout |
| `-max-concurrent` | `20` | Max concurrent health checks |

## Dashboard

Open `http://localhost:8080` for the web dashboard:

- View all proxies with country/city info
- See current active proxy
- Click any proxy to switch manually
- Trigger manual pool refresh

### API

```
GET  /api/status           # Pool status JSON
POST /api/refresh          # Trigger pool refresh
GET  /api/switch           # Switch to next proxy
GET  /api/switch?index=N   # Switch to specific proxy
```

## Deployment

### Docker Compose (Recommended)

```bash
# Clone the repository
git clone https://github.com/yourusername/socks5-proxy.git
cd socks5-proxy

# Copy environment file
cp .env.example .env

# Start with Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f
```

### Docker

```bash
# Using pre-built image from GitHub Container Registry
docker pull ghcr.io/yourusername/socks5-proxy:latest
docker run -d -p 1080:1080 -p 8080:8080 ghcr.io/yourusername/socks5-proxy:latest

# Or build locally
docker build -t socks5-pool .
docker run -p 1080:1080 -p 8080:8080 socks5-pool
```

### Railway

The project includes `railway.toml` for one-click Railway deployment.

📖 **For detailed deployment instructions, see [DEPLOY.md](DEPLOY.md)**

## Project Structure

```
├── main.go        # Entry point, refresh & rotation loops
├── config.go      # CLI flag parsing
├── server.go      # SOCKS5 protocol implementation
├── pool.go        # Proxy pool management
├── scraper.go     # Proxy list scraping
├── checker.go     # Health checks & geo lookup
├── status.go      # Web dashboard & API
├── Dockerfile     # Multi-stage Docker build
└── railway.toml   # Railway deployment config
```
