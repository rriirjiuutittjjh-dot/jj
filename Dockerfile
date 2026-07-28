FROM debian:trixie-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and clean up in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    sudo \
    qemu-system-x86 \
    && rm -rf /var/lib/apt/lists/*

# Manually download and install the official ttyd binary (v1.7.7)
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then TTYD_ARCH="x86_64"; \
    elif [ "$ARCH" = "aarch64" ]; then TTYD_ARCH="aarch64"; \
    else echo "Unsupported architecture: $ARCH" && exit 1; fi && \
    wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.${TTYD_ARCH} && \
    chmod +x /usr/local/bin/ttyd

# Create a non-root user with passwordless sudo rights
RUN useradd -m -u 1000 user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to non-root user
USER user
WORKDIR /home/user

# Copy and setup start script
COPY --chown=user:user start.sh /home/user/start.sh
RUN chmod +x /home/user/start.sh

# Expose Railway's required port
EXPOSE 8080

ENTRYPOINT ["/home/user/start.sh"]
