FROM node:18-alpine

RUN apk add --no-cache \
    bash \
    # minimal libs for Puppeteer to run
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    fontconfig

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
