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
    | tar xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/gotty

# 3. Expose GoTTY port
EXPOSE 8080

# 4. Use tini as PID 1
ENTRYPOINT ["/usr/bin/tini", "--"]

# 5. Launch GoTTY with a 32-character random URL path
CMD ["gotty", \
     "--port", "8080", \
     "--permit-write", \
     "--random-url", \
     "--random-url-length", "32", \
     "bash"]
