FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install minimal prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl ca-certificates bash tini && \
    rm -rf /var/lib/apt/lists/*

# 2. Download and install GoTTY v1.0.1 binary
RUN curl -fsSL \
      https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz \
    | tar xz -C /usr/local/bin gotty && \
    chmod +x /usr/local/bin/gotty

# 3. (Optional) Customize the shell prompt and alias for 'poweroff'
RUN echo "export PS1='\\u@\\h:\\w\\$ '" >> /etc/profile && \
    echo "alias poweroff='kill 1'" >> /etc/profile

# 4. Expose GoTTY’s default port
EXPOSE 8080

# 5. Use tini as PID 1 for clean signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# 6. Launch GoTTY on your custom base path with write permission
CMD ["gotty", \
     "--port", "8080", \
     "--base", "/7190@99146#6819/ppqp@GaeylpYy/ppYTR681#@o", \
     "--permit-write", \
     "bash"]
