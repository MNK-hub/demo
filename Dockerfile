FROM ubuntu:22.04

# Non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install GoTTY prerequisites and Go compiler
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl ca-certificates git build-essential golang-go bash tini && \
    rm -rf /var/lib/apt/lists/*

# Install GoTTY
RUN go install github.com/yudai/gotty@latest

# Ensure Go bin is in PATH
ENV PATH=$PATH:/root/go/bin

# Optional: customize prompt and alias
RUN echo "export PS1='\u@\h:\w\$ '" >> /etc/profile && \
    echo "alias poweroff='kill 1'" >> /etc/profile

# Expose GoTTY default port
EXPOSE 8080

# Use tini as PID 1 for signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# Start GoTTY on /, running bash
CMD ["gotty", "--port", "8080", "--base", "/", "--permit-write", "bash"]
