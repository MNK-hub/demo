FROM ubuntu:latest

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tini \
        ttyd \
        socat \
        nginx \
        unzip \
        openssl \
        openssh-client \
        ca-certificates \
        wget && \
    rm -rf /var/lib/apt/lists/* && \
# Configure nginx
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    mkdir -p /run/nginx && \
    echo "server { listen 80 default_server; root /var/www/html; location / { try_files \$uri /index.html; } }" > /etc/nginx/sites-available/default && \
    echo "<html><head><title>Welcome to Nginx</title></head><body><h1>Nginx works!</h1></body></html>" > /var/www/html/index.html && \
    chown -R www-data:www-data /var/www/html && \
# Configure a nice terminal prompt
    echo "export PS1='\033[01;32m\u@\h\033[00m:\033[01;34m\w\033[00m\$ '" >> /etc/profile && \
# Fake poweroff
    echo "alias poweroff='kill 1'" >> /etc/profile

ENV TINI_KILL_PROCESS_GROUP=1

EXPOSE 7681 80

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["ttyd", "-s", "3", "-t", "titleFixed=/bin/bash", "-t", "rendererType=webgl", "-t", "disableLeaveAlert=true", "/bin/bash", "-i", "-l"]
