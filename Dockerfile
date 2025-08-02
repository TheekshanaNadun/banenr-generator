FROM node:18-alpine

RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.21/community" >> /etc/apk/repositories

RUN apk update && apk add --no-cache \
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
    gst-plugins-base \
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
    libxtst \
    mesa-gl \
    pango \
    pulseaudio \
    ttf-freefont \
    && rm -rf /var/cache/apk/*
