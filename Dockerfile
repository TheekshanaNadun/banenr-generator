FROM node:18-alpine

# Install Chromium and all required dependencies for Puppeteer
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    fontconfig \
    bash \
    chromium-chromedriver \
    alsa-lib \
    atk \
    cairo \
    cups-libs \
    dbus-libs \
    eudev-libs \
    expat \
    flac \
    gdk-pixbuf \
    giflib \
    glib \
    gst-plugins-base-libs \
    harfbuzz-icu \
    icu-libs \
    jpeg \
    libice \
    libsm \
    libx11 \
    libxcomposite \
    libxcursor \
    libxdamage \
    libxext \
    libxfixes \
    libxi \
    libxinerama \
    libxrandr \
    libxrender \
    libxss \
    libxtst \
    mesa-gl \
    pango \
    pulseaudio \
    ttf-freefont \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

EXPOSE 3000

CMD ["node", "server.js"]
