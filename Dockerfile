FROM node:18-bullseye

# Install dependencies required for wkhtmltopdf
RUN apt-get update && apt-get install -y \
    wget \
    xz-utils \
    fontconfig \
    libfreetype6 \
    libjpeg62-turbo \
    libx11-6 \
    libxcb1 \
    libxext6 \
    libxrender1 \
    libglib2.0-0 \
    libssl1.1 || true

# Download and install wkhtmltox
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bullseye_amd64.deb && \
    dpkg -i wkhtmltox_0.12.6.1-3.bullseye_amd64.deb || apt-get install -f -y && \
    rm wkhtmltox_0.12.6.1-3.bullseye_amd64.deb

# Set work directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy rest of the app
COPY . .

# Expose port (important for CapRover)
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
