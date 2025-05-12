FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install minimal prerequisites + nginx + tini
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl ca-certificates bash tini nginx && \
    rm -rf /var/lib/apt/lists/*

# 2. Fetch and install GoTTY v1.0.1 binary
RUN curl -fsSL \
      https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz \
    | tar xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/gotty

# 3. Configure Nginx as a reverse-proxy for GoTTY
RUN rm /etc/nginx/sites-enabled/default && \
    cat > /etc/nginx/conf.d/gotty.conf << 'EOF' 
server {
    listen 8080;
    # Only serve on this custom path:
    location /7190@99146#6819/ppqp@GaeylpYy/ppYTR681#@o {
        proxy_pass http://127.0.0.1:8081/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
    # Optionally return 404 elsewhere
    location / {
        return 404;
    }
}
EOF

# 4. Expose only the public port
EXPOSE 8080

# 5. Use tini as PID 1 for proper signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# 6. Start GoTTY (internal) and Nginx (foreground)
CMD bash -lc "\
    gotty --address 127.0.0.1 --port 8081 --permit-write bash & \
    nginx -g 'daemon off;';"
