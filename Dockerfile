FROM node:18-alpine

# Install dependencies Puppeteer needs on Alpine
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    fontconfig \
    bash

# Set working directory
WORKDIR /app

# Copy package files and install dependencies (puppeteer will download Chromium automatically)
COPY package*.json ./
RUN npm install

# Copy app source
COPY . .

# Set env variable so Puppeteer uses installed chromium binary (optional but recommended)
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Expose port 3000
EXPOSE 3000

# Start your server
CMD ["node", "server.js"]
