#!/bin/bash
set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPENDENCY_DIR="$WORKSPACE_DIR/dependency"

mkdir -p "$DEPENDENCY_DIR"
cd "$DEPENDENCY_DIR"

echo "=================================================="
echo " 2. Linux Kernel Source & Build Pipeline"
echo "=================================================="

if [ ! -d "linux" ]; then
    echo ">>> Cloning Linux Kernel..."
    git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git --depth 1 --branch linux-6.6.y linux
fi

echo ">>> Building Linux Kernel, zImage, and DTB..."
cd linux
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- imx_v6_v7_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) zImage dtbs modules

# Copy requested artifacts to workspace root or dependency dir
cp arch/arm/boot/zImage "$WORKSPACE_DIR/dependency/zImage"
cp arch/arm/boot/dts/nxp/imx/imx6q-sabrelite.dtb "$WORKSPACE_DIR/dependency/imx6q-sabrelite.dtb"
cd ..

echo ">>> Linux Kernel step completed successfully!"