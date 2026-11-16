#!/bin/bash
set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPENDENCY_DIR="$WORKSPACE_DIR/dependency"

mkdir -p "$DEPENDENCY_DIR"
cd "$DEPENDENCY_DIR"

echo "=================================================="
echo " 1. U-Boot Source & Build Pipeline"
echo "=================================================="

if [ ! -d "u-boot" ]; then
    echo ">>> Cloning U-Boot..."
    git clone https://source.denx.de/u-boot/u-boot.git --depth 1 --branch v2024.01 u-boot
fi

echo ">>> Building U-Boot..."
cd u-boot
make CROSS_COMPILE=arm-linux-gnueabihf- mx6qsabrelite_defconfig
make CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc)
cp u-boot "$WORKSPACE_DIR/dependency/u-boot-bin"
cd ..
echo ">>> U-Boot step completed successfully!"