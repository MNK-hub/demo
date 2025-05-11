FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl ca-certificates openssh-client \
        nodejs npm bash tini && \
    npm install -g wetty && \
    rm -rf /var/lib/apt/lists/*

# Add fake poweroff
RUN echo "alias poweroff='kill 1'" >> /etc/profile && \
    echo "export PS1='\033[01;32m\u@\h\033[00m:\033[01;34m\w\033[00m\$ '" >> /etc/profile

# Use tini for proper PID 1 handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# Run Wetty on port 3000
CMD ["wetty", "--port", "3000", "--command", "/bin/bash"]

EXPOSE 3000
