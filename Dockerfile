FROM node:18-bullseye

RUN apt-get update && apt-get install -y \
    wkhtmltopdf \
    xvfb \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
