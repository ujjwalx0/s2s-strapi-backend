# Stage 1: Builder
FROM node:20-alpine AS builder
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps

# Copy and build
COPY . .
RUN npm run build

# Convert TS configs to JS for production
RUN find config -name "*.ts" | while read f; do \
      npx tsc "$f" --module commonjs --esModuleInterop true --skipLibCheck true --outDir $(dirname "$f"); \
      mv "${f%.ts}.js" "$f"; \
    done

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

# Environment
ENV NODE_ENV=production
ENV PORT=1337
EXPOSE 1337

CMD ["npm", "start"]