FROM node:18-slim

# Install only what's needed
RUN apt-get update && apt-get install -y \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working dir
WORKDIR /app

# Copy files
COPY package*.json ./

# Install puppeteer with Chromium bundled
RUN npm install

# Copy rest of the app
COPY . .

# Expose port
EXPOSE 3000

# Start server
CMD ["node", "server.js"]
