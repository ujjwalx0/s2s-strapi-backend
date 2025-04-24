# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Runtime
FROM node:20-alpine
WORKDIR /app

# Copy required files
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/build ./build
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