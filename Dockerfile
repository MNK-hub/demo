# Use Ubuntu as the base (you get a full root system)
FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install and configure OpenSSH
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server bash && \
    rm -rf /var/lib/apt/lists/* && \
    \
    # Ensure sshd can start (create runtime dir)
    mkdir -p /var/run/sshd && \
    \
    # Generate host keys on build (optional; you can also do this at runtime)
    ssh-keygen -A && \
    \
    # Set root password to 'root' (change this in production!)
    echo 'root:root' | chpasswd && \
    \
    # Permit root login with password
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/'  /etc/ssh/sshd_config

# 2. (Optional) a nicer prompt for root
RUN echo "export PS1='\\u@\\h:\\w\\$ '" >> /etc/profile

# 3. Expose SSH port
EXPOSE 22

# 4. Start sshd in foreground
CMD ["/usr/sbin/sshd","-D"]
