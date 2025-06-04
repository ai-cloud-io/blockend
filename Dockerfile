FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN apt-get update && apt-get install -y netcat-openbsd
RUN chmod +x start.sh
CMD ["sh", "start.sh"]