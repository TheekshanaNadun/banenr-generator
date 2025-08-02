FROM node:18-bullseye

# Install necessary dependencies for Chromium (bundled by Puppeteer)
RUN apk add --no-cache \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    fontconfig \
    chromium \
    # We include chromium here only for dependencies (you can remove 'chromium' if not required)
    # but Puppeteer will use its own Chromium

    bash \
    # Some Puppeteer dependencies for Alpine
    && rm -rf /var/cache/apk/*

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (this downloads Chromium by Puppeteer)
RUN npm install

# Copy app source
COPY . .

# Expose port
EXPOSE 3000

# No need to set PUPPETEER_EXECUTABLE_PATH; Puppeteer uses its own Chromium by default

CMD ["node", "server.js"]
