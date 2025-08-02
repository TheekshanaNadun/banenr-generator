FROM node:18-bullseye

# Install required minimal dependencies
RUN apt-get update && apt-get install -y \
    fontconfig libfreetype6 libjpeg62-turbo libx11-6 libxcb1 libxext6 libxrender1 libssl1.1 libglib2.0-0 wget

# Download static wkhtmltox binary and extract
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6-1.bullseye_amd64.tar.xz \
    && tar -xJf wkhtmltox_0.12.6-1.bullseye_amd64.tar.xz \
    && cp wkhtmltox/bin/wkhtmltoimage /usr/local/bin/ \
    && rm -rf wkhtmltox wkhtmltox_0.12.6-1.bullseye_amd64.tar.xz

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000
CMD ["node", "server.js"]
