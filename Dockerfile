# Stage 1: Builder
FROM node:20-alpine AS builder
WORKDIR /app

# Install dependencies first (caching layer)
COPY package.json yarn.lock* package-lock.json* ./
RUN npm install --legacy-peer-deps  # Required for Strapi v5

# Copy source and build
COPY . .
RUN npm run build

# Verify build output location (Strapi v5 specific)
RUN ls -la /app/dist  # Strapi v5 uses /dist instead of /build

# Stage 2: Runtime
FROM node:20-alpine
WORKDIR /app

# Copy production assets
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist 
COPY --from=builder /app/config ./config
COPY --from=builder /app/public ./public
COPY --from=builder /app/.cache ./.cache  
COPY --from=builder /app/ca.pem ./ca.pem  

# Security
RUN chown -R node:node /app
USER node

# Environment
ENV NODE_ENV=production
ENV PORT=1337
EXPOSE 1337

CMD ["npm", "start"]