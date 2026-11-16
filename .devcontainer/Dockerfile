FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential build tools, cross-compilers, and dependencies required for
# Linux kernel, U-Boot, BusyBox, and Vim compilation.
RUN apt-get update && apt-get install -y \
    build-essential \
    crossbuild-essential-armhf \
    crossbuild-essential-arm64 \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    bc \
    bison \
    flex \
    libssl-dev \
    libncurses5-dev \
    libelf-dev \
    libgmp3-dev \
    libmpc-dev \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    libglib2.0-dev \
    libpixman-1-dev \
    git \
    wget \
    curl \
    cpio \
    rsync \
    kmod \
    u-boot-tools \
    python3 \
    python3-dev \
    python3-pip \
    vim \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user 'builder' to avoid permission issues with mounted volumes
RUN useradd -ms /bin/bash builder && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER builder
WORKDIR /home/builder

# Set default environment variables for cross-compilation convenience
ENV ARCH=arm
ENV CROSS_COMPILE=arm-linux-gnueabihf-

CMD ["/bin/bash"]
