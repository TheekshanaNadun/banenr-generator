FROM node:18-bullseye

# Install dependencies for wkhtmltoimage
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

# Download and install wkhtmltox
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bullseye_amd64.deb \
  && dpkg -i wkhtmltox_0.12.6.1-3.bullseye_amd64.deb || true \
  && apt-get install -f -y \
  && rm wkhtmltox_0.12.6.1-3.bullseye_amd64.deb

# ✅ Ensure wkhtmltoimage is in PATH
RUN ln -s $(which wkhtmltoimage) /usr/bin/wkhtmltoimage || true

# Copy your files
WORKDIR /app
COPY . .

# Install node modules
RUN npm install

# Expose port and run the server
EXPOSE 3000
CMD ["node", "server.js"]
