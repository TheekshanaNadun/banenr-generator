FROM node:18-alpine

# Install dependencies for Chromium
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    npm

# Set the working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your app
COPY . .

# Set env for Puppeteer to use Chromium installed by APK
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Expose port if needed
EXPOSE 3000

# Run your server
CMD ["node", "server.js"]
