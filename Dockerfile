FROM node:18-bullseye

# Install dependencies
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

# Install wkhtmltox with wkhtmltoimage
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bullseye_amd64.deb \
  && apt install -y ./wkhtmltox_0.12.6.1-3.bullseye_amd64.deb \
  && rm wkhtmltox_0.12.6.1-3.bullseye_amd64.deb

# Confirm it’s installed and accessible
RUN which wkhtmltoimage && wkhtmltoimage --version

# Setup app
WORKDIR /app
COPY . .
RUN npm install

EXPOSE 3000
CMD ["node", "server.js"]
