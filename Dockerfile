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

# 3. Configure Nginx as reverse-proxy for GoTTY
RUN rm /etc/nginx/sites-enabled/default

RUN bash -c "cat << 'EOF' > /etc/nginx/conf.d/gotty.conf
server {
    listen 8080;

    # Serve ONLY on this custom path:
    location /7190@99146#6819/ppqp@GaeylpYy/ppYTR681#@o {
        proxy_pass http://127.0.0.1:8081/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
    }

    # Return 404 elsewhere
    location / {
        return 404;
    }
}
EOF"

# 4. (Optional) Customize prompt & alias
RUN echo "export PS1='\\u@\\h:\\w\\$ '" >> /etc/profile && \
    echo "alias poweroff='kill 1'" >> /etc/profile

# 5. Expose only the public port
EXPOSE 8080

# 6. Use tini for proper PID 1 handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# 7. Start GoTTY (internal) and Nginx (foreground)
CMD bash -lc "\
    gotty --address 127.0.0.1 --port 8081 --permit-write bash & \
    nginx -g 'daemon off;';"
