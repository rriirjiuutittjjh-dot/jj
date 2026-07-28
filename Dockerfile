FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    ca-certificates \
    sudo \
    docker.io \
    qemu-system-x86 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user with passwordless sudo rights
RUN useradd -m -u 1000 user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER user
WORKDIR /home/user

# Copy and setup start script
COPY --chown=user:user start.sh /home/user/start.sh
RUN chmod +x /home/user/start.sh

# (Optional) If sshx handles session management directly, explicit ports aren't always required, 
# but you can leave EXPOSE if needed by your hosting platform.
EXPOSE 8080

ENTRYPOINT ["/home/user/start.sh"]
