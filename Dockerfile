# Stage 1: Builder
FROM node:20-alpine AS builder
WORKDIR /app

# Install dependencies including TypeScript
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps && \
    npm install typescript --save-dev

# Copy and build
COPY . .
RUN npm run build

# Convert TS configs to JS (simplified approach)
RUN find config -name "*.ts" -exec sh -c 'npx tsc "$1" --module commonjs --esModuleInterop --skipLibCheck && mv "${1%.ts}.js" "$1"' _ {} \;

# Stage 2: Runtime
FROM node:20-alpine
WORKDIR /app

# Copy production files
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/config ./config
COPY --from=builder /app/public ./public
COPY --from=builder /app/ca.pem ./ca.pem

# Security
RUN chown -R node:node /app
USER node

ENV NODE_ENV=production
ENV PORT=1337
EXPOSE 1337

CMD ["npm", "start"]