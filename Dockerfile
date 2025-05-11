FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies + NodeSource Node.js 20
RUN apt-get update && \
    apt-get install -y curl ca-certificates gnupg openssh-client bash tini && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g wetty && \
    rm -rf /var/lib/apt/lists/*

# Customize terminal
RUN echo "alias poweroff='kill 1'" >> /etc/profile && \
    echo "export PS1='\033[01;32m\u@\h\033[00m:\033[01;34m\w\033[00m\$ '" >> /etc/profile

# Port for Wetty
EXPOSE 3000

# PID 1 support
ENTRYPOINT ["/usr/bin/tini", "--"]

# Start Wetty terminal
CMD ["wetty", "--port", "3000", "--command", "/bin/bash"]
