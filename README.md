# Azure Claude Proxy

将 Cursor IDE 连接到 Azure Anthropic API (Claude) 的代理服务。

## 快速开始

### Docker 部署（推荐）

```bash
docker run -d \
  --name azure-claude-proxy \
  -p 8080:8080 \
  -e AZURE_ENDPOINT=https://<resource>.openai.azure.com/anthropic/v1/messages \
  -e AZURE_API_KEY=your-azure-api-key \
  -e SERVICE_API_KEY=your-random-secret-key \
  -e AZURE_DEPLOYMENT_NAME=claude-opus-4-5 \
  hanjiaming/azure-claude-proxy:latest
```

### Docker Compose 部署

创建 `docker-compose.yml`：

```yaml
services:
  azure-claude-proxy:
    image: hanjiaming/azure-claude-proxy:latest
    ports:
      - "${PORT:-8080}:8080"
    environment:
      - AZURE_ENDPOINT=${AZURE_ENDPOINT}
      - AZURE_API_KEY=${AZURE_API_KEY}
      - SERVICE_API_KEY=${SERVICE_API_KEY}
      - AZURE_DEPLOYMENT_NAME=${AZURE_DEPLOYMENT_NAME:-claude-opus-4-5}
      - PORT=8080
    restart: unless-stopped
```

创建 `.env` 文件：

```env
AZURE_ENDPOINT=https://<resource>.openai.azure.com/anthropic/v1/messages
AZURE_API_KEY=your-azure-api-key
SERVICE_API_KEY=your-random-secret-key
AZURE_DEPLOYMENT_NAME=claude-opus-4-5
```

启动：

```bash
docker compose up -d
```

### Railway 部署

1. 在 [Railway](https://railway.app) 上创建新项目，关联 GitHub 仓库
2. 在 **Variables** 标签中配置环境变量
3. Railway 会自动检测并完成部署
4. 访问 `https://your-app.up.railway.app/health` 验证

![Railway 环境变量配置](screenshot/railway-var.png)

![Railway 自定义域名配置](screenshot/railway-domain.png)

## 环境变量

| 变量 | 必填 | 默认值 | 说明 |
|------|------|--------|------|
| `AZURE_ENDPOINT` | 是 | - | Azure Anthropic API 端点 |
| `AZURE_API_KEY` | 是 | - | Azure API 密钥 |
| `SERVICE_API_KEY` | 是 | - | 用于验证 Cursor IDE 请求的密钥 |
| `AZURE_DEPLOYMENT_NAME` | 否 | `claude-opus-4-5` | Azure 部署名称 |
| `PORT` | 否 | `8080` | 服务端口 |

## Cursor IDE 配置

1. 打开 Cursor Settings
2. 找到 Model 设置，启用 "Opus 4.5"
3. 设置 OpenAI Custom API URL 为你的服务地址（如 `http://localhost:8080` 或 Railway URL）
4. 设置 OpenAI API Key 为 `SERVICE_API_KEY` 的值，并启用

![Cursor Model 配置](screenshot/cursor-model.png)

![Cursor Chat 配置](screenshot/cursor-chat.png)

> **注意**：Cursor IDE 中的 API Key 必须与服务端 `SERVICE_API_KEY` 环境变量完全一致。

## API 接口

| 方法 | 路径 | 说明 |
|------|------|------|
| `GET` | `/` | 服务状态及可用接口 |
| `GET` | `/health` | 健康检查 |
| `POST` | `/chat/completions` | Cursor IDE 主要接口（OpenAI 格式） |
| `POST` | `/v1/chat/completions` | OpenAI 兼容接口 |
| `POST` | `/v1/messages` | Anthropic 原生格式 |

### 测试

```bash
curl -X POST http://localhost:8080/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_SERVICE_API_KEY" \
  -d '{
    "model": "claude-opus-4-5",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## 本地开发

```bash
npm install
npm start
```

## License

MIT

## 参考

本项目参考了 [Cursor-Azure-GPT-5](https://github.com/gabrii/Cursor-Azure-GPT-5)。
