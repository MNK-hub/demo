FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and Node.js 20
RUN apt-get update && \
    apt-get install -y curl ca-certificates gnupg openssh-client bash tini build-essential python3 && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g wetty && \
    rm -rf /var/lib/apt/lists/*

# Set up a basic prompt and alias for 'poweroff'
RUN echo "alias poweroff='kill 1'" >> /etc/profile && \
    echo "export PS1='\033[01;32m\u@\h\033[00m:\033[01;34m\w\033[00m\$ '" >> /etc/profile

# Expose Wetty port
EXPOSE 3000

# tini as PID 1
ENTRYPOINT ["/usr/bin/tini", "--"]

# Start Wetty (force shell and base path)
CMD ["wetty", "--port", "3000", "--base", "/", "--command", "/bin/bash"]
