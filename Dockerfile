FROM node:20-alpine AS builder
WORKDIR /app

COPY package.json . 
COPY package-lock.json . 
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json . 
COPY --from=builder /app/package-lock.json . 
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/config ./config
COPY --from=builder /app/public ./public

COPY --from=builder /app/ca.pem ./ca.pem

RUN chown -R node:node /app
USER node

ENV NODE_ENV=production
ENV PORT=1337
EXPOSE 1337

CMD ["npm", "start"]
