# Stage 1: Build and install production dependencies
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package manifests
COPY package*.json ./
COPY server/package*.json ./server/

# Install only production dependencies
RUN npm ci --omit=dev && \
    cd server && npm ci --omit=dev

# Stage 2: Minimal runner image
FROM node:18-alpine

WORKDIR /app

# Copy installed node_modules from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server/node_modules ./server/node_modules

# Copy application source code
COPY . .

EXPOSE 5000

ENV NODE_ENV=production
ENV PORT=5000

CMD ["npm", "start"]
