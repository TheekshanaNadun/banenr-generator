FROM node:18-bullseye

# Install necessary dependencies for Chromium (needed by Puppeteer)
RUN apt-get update && apt-get install -y \
    ca-certificates \
    fonts-freefont-ttf \
    libnss3 \
    libfreetype6 \
    libharfbuzz0b \
    fontconfig \
    chromium \
    bash \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (this will download Chromium bundled with Puppeteer)
RUN npm install

# Copy app source
COPY . .

# Expose port
EXPOSE 3000

# Puppeteer uses its own Chromium by default, so no need to set executable path
CMD ["node", "server.js"]
