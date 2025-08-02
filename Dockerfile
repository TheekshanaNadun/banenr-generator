FROM node:18-alpine

# Install dependencies
RUN apk add --no-cache \
  chromium \
  nss \
  freetype \
  harfbuzz \
  ca-certificates \
  ttf-freefont \
  nodejs \
  yarn

# Set environment variables
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Create app directory
WORKDIR /app

# Copy package files and install
COPY package*.json ./
RUN npm install

# Copy the rest of the code
COPY . .

# Run app
CMD ["node", "server.js"]
