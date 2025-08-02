FROM node:18-bullseye

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
    libssl1.1 \
    libglib2.0-0

# Download wkhtmltoimage static build
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bullseye_amd64.deb \
  && dpkg -i wkhtmltox_0.12.6-1.bullseye_amd64.deb \
  && rm wkhtmltox_0.12.6-1.bullseye_amd64.deb

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000
CMD ["node", "server.js"]
