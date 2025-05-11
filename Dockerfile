FROM ubuntu:22.04

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive
ENV TINI_KILL_PROCESS_GROUP=1

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential cmake git curl unzip wget \
        libjson-c-dev libwebsockets-dev \
        nginx \
        openssh-client ca-certificates \
        tini pkg-config \
        bash && \
    rm -rf /var/lib/apt/lists/*

# Build ttyd from source (latest and mobile-friendly)
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && make && make install && \
    cd / && rm -rf ttyd

# Nginx basic setup
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    mkdir -p /run/nginx && \
    echo "server { listen 80 default_server; root /var/www/html; location / { try_files \$uri /index.html; } }" > /etc/nginx/sites-available/default && \
    echo "<html><head><title>Nginx</title></head><body><h1>Nginx is OK</h1></body></html>" > /var/www/html/index.html && \
    chown -R www-data:www-data /var/www/html

# Terminal UI tweaks
RUN echo "export PS1='\033[01;32m\u@\h\033[00m:\033[01;34m\w\033[00m\$ '" >> /etc/profile && \
    echo "alias poweroff='kill 1'" >> /etc/profile

# Expose ports: ttyd, nginx
EXPOSE 7681 80

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["ttyd", "-s", "3", "-t", "titleFixed=Ubuntu Mobile Terminal", "-t", "rendererType=webgl", "-t", "disableLeaveAlert=true", "/bin/bash", "-i", "-l"]
