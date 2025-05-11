FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install all needed dependencies and Wetty
RUN apt-get update && \
    apt-get install -y \
        curl ca-certificates gnupg openssh-client \
        bash tini build-essential python3 \
        git wget && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g wetty && \
    rm -rf /var/lib/apt/lists/*

# Fix mobile input issue: set TERM
ENV TERM xterm-256color

# Optional: a cleaner prompt
RUN echo "export PS1='\u@\h:\w\$ '" >> /etc/profile

# Expose Wetty default port
EXPOSE 3000

# Use tini for proper PID 1 handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# CMD: Start wetty with bash shell (very important!)
CMD ["wetty", "--port", "3000", "--base", "/", "--command", "/bin/bash"]
