# Stage 1: Use npm install to build app
#FROM node:24
FROM cgr.dev/chainguard/node:latest-dev AS builder
    
WORKDIR /app

COPY --chown=node:node package*.json ./

RUN npm install --production

# Stage 2: Only production utils and assets
FROM cgr.dev/chainguard/node:latest
WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules/ ./node_modules
COPY src ./src
COPY tsconfig.json ./
COPY nodemon.json ./ 
COPY .env ./ 

ENV NODE_ENV=production
EXPOSE 8000

ENTRYPOINT ["npm", "run", "prod"]
