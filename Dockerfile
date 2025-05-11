FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install minimal prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl ca-certificates bash tini && \
    rm -rf /var/lib/apt/lists/*

# 2. Fetch and install GoTTY binary (v1.0.1)
RUN curl -fsSL \
      https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz \
    | tar xz -C /usr/local/bin --strip-components=1 gotty_linux_amd64/gotty && \
    chmod +x /usr/local/bin/gotty

# 3. (Optional) Customize prompt and alias
RUN echo "export PS1='\\u@\\h:\\w\\$ '" >> /etc/profile && \
    echo "alias poweroff='kill 1'" >> /etc/profile

# 4. Expose default GoTTY port
EXPOSE 8080

# 5. Use tini for proper signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# 6. Run GoTTY, permitting input
CMD ["gotty", "--port", "8080", "--base", "/", "--permit-write", "bash"]
