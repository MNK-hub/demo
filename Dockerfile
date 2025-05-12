FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install minimal prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl ca-certificates bash tini && \
    rm -rf /var/lib/apt/lists/*

# 2. Download and install GoTTY v1.0.1 binary
#    (extract everything – the gotty binary is at the archive root)
RUN curl -fsSL \
      https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz \
    | tar xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/gotty

# 3. (Optional) Customize your prompt and add 'poweroff' alias
RUN echo "export PS1='\\u@\\h:\\w\\$ '" >> /etc/profile && \
    echo "alias poweroff='kill 1'" >> /etc/profile

# 4. Expose the GoTTY port
EXPOSE 8080

# 5. Use tini for proper PID 1 handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# 6. Launch GoTTY on your custom base path, permitting write access
CMD ["gotty", \
     "--port", "8080", \
     "--base", "/7190@99146#6819/ppqp@GaeylpYy/ppYTR681#@o", \
     "--permit-write", \
     "bash"]
