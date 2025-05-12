FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install openssh-server and bash
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openssh-server bash && \
    mkdir -p /var/run/sshd && \
    rm -rf /var/lib/apt/lists/*

# 2. Configure root login (password = 'root'; change as soon as you can)
RUN echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config

# 3. (Optional) a nicer prompt
RUN echo "export PS1='\\u@\\h:\\w\\$ '" >> /etc/profile

# 4. Expose SSH port
EXPOSE 22

# 5. Start sshd in foreground
CMD ["/usr/sbin/sshd","-D"]
