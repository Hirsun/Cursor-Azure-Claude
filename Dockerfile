FROM node:18-alpine

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm ci --omit=dev || npm install --omit=dev

COPY server.js .

EXPOSE 8080

USER node

CMD ["node", "server.js"]
