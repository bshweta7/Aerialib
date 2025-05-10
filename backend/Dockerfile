#FROM node:24
FROM cgr.dev/chainguard/node:latest-dev
    
WORKDIR /app

COPY --chown=node:node package*.json ./

# TODO see if double is still needed
RUN npm install

COPY src ./src
COPY tsconfig.json ./
COPY nodemon.json ./ 
COPY .env ./ 
# TODO multistage docker build 

EXPOSE 8000


ENV NODE_ENV=production
ENTRYPOINT ["npm", "run", "prod"]