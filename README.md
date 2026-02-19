# Azure Anthropic Proxy for Cursor

代理服务器，用于将 Cursor IDE 连接到 Azure Anthropic API (Claude)。

## 📋 接口列表

### 根路径

-   `GET /` - 服务器信息及可用接口

### 健康检查

-   `GET /health` - 检查服务器运行状态

### 聊天接口

-   `POST /chat/completions` - Cursor IDE 主要使用的接口（OpenAI 格式）
-   `POST /v1/chat/completions` - OpenAI 格式
-   `POST /v1/messages` - Anthropic 原生格式

## ⚙️ 环境变量

| 变量 | 必填 | 默认值 | 说明 |
|------|------|--------|------|
| `AZURE_ENDPOINT` | 是 | - | Azure Anthropic API 端点 |
| `AZURE_API_KEY` | 是 | - | Azure API 密钥 |
| `SERVICE_API_KEY` | 是 | - | 用于验证 Cursor IDE 请求的密钥 |
| `AZURE_DEPLOYMENT_NAME` | 否 | `claude-opus-4-5` | Azure 部署名称 |
| `PORT` | 否 | `8080` | 服务端口 |

## 🐳 Docker 部署（推荐）

### 1. 准备环境变量

```bash
cp .env.example .env
```

编辑 `.env` 文件，填入实际的配置值：

```env
AZURE_ENDPOINT=https://<resource>.openai.azure.com/anthropic/v1/messages
AZURE_API_KEY=your-azure-api-key
SERVICE_API_KEY=your-random-secret-key
AZURE_DEPLOYMENT_NAME=claude-opus-4-5
PORT=8080
```

### 2. 启动服务

```bash
docker compose up -d --build
```

### 3. 常用命令

```bash
# 查看日志
docker compose logs -f

# 停止服务
docker compose down

# 重新构建并启动
docker compose up -d --build
```

## 📦 本地运行

```bash
npm install
npm start
```

## 🚂 Railway 部署

1. 在 [Railway](https://railway.app) 上创建新项目，关联 GitHub 仓库
2. 在 **Variables** 标签中配置上述环境变量
3. Railway 会自动检测 Node.js 项目并完成部署
4. 部署成功后访问 `https://your-app.up.railway.app/health` 验证

![Railway 环境变量配置](screenshot/railway-var.png)

![Railway 自定义域名配置](screenshot/railway-domain.png)

## 🔧 Cursor IDE 配置

1. 打开 Cursor Settings
2. 找到 Model 设置，启用 "Opus 4.5"
3. 设置 OpenAI Custom API URL 为你的服务地址（如 `http://localhost:8080` 或 Railway URL）
4. 设置 OpenAI API Key 为 `SERVICE_API_KEY` 的值，并启用

![Cursor Model 配置](screenshot/cursor-model.png)

![Cursor Chat 配置](screenshot/cursor-chat.png)

> **注意**：Cursor IDE 中的 API Key 必须与服务端 `SERVICE_API_KEY` 环境变量完全一致，否则请求会被拒绝。

### 测试请求

```bash
curl -X POST http://localhost:8080/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_SERVICE_API_KEY" \
  -d '{
    "model": "claude-opus-4-5",
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

## 📝 License

MIT

## 🙏 参考

本项目参考了 [Cursor-Azure-GPT-5](https://github.com/gabrii/Cursor-Azure-GPT-5)。
