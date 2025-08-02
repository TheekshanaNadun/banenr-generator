FROM node:18-alpine

RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    fontconfig \
    bash \
    libc6-compat

WORKDIR /app

COPY package*.json ./

# Skip Puppeteer’s Chromium download (too big and wrong arch)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN npm install

COPY . .

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

EXPOSE 3000

CMD ["node", "server.js"]
