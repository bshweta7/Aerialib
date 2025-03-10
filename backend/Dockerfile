FROM node:18
    
WORKDIR /app

COPY package*.json ./

# TODO see if double is still needed
RUN npm install 
RUN npm install 

COPY src ./src
COPY tsconfig.json ./
COPY nodemon.json ./ 
# TODO multistage docker build 

EXPOSE 8000

CMD ["npm", "run", "dev"]