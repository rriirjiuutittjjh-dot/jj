FROM debian:trixie-slim

USER root
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies including ttyd and QEMU
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    ttyd \
    qemu-system-x86 \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user with passwordless sudo
RUN useradd -m -u 1000 user && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER skaosw
WORKDIR /home/user

# Copy and setup start script
COPY --chown=user:user start.sh /home/user/start.sh
RUN chmod +x /home/user/start.sh

# Expose Railway's required port
EXPOSE 8080

ENTRYPOINT ["/home/user/start.sh"]
