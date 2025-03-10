FROM node:18
    
WORKDIR /app

COPY package*.json ./
COPY . .

# TODO see if double is still needed
RUN npm install 
RUN npm install 

EXPOSE 8000

CMD ["npm", "run", "dev"]