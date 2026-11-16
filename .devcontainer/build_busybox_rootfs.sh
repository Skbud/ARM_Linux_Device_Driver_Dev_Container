#!/bin/bash
set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPENDENCY_DIR="$WORKSPACE_DIR/dependency"

mkdir -p "$DEPENDENCY_DIR"
cd "$DEPENDENCY_DIR"

echo "=================================================="
echo " 3. BusyBox, RootFS, Modules Registration & CPIO"
echo "=================================================="

# 1. BusyBox Source & Compilation
if [ ! -d "busybox" ]; then
    echo ">>> Cloning BusyBox..."
    git clone https://git.busybox.net/busybox --depth 1 --branch 1_36_1 busybox
fi

echo ">>> Compiling BusyBox..."
cd busybox
make defconfig

# Force static build so it doesn't require shared libraries in rootfs which results in kernel panic of no init found
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config

echo ">>> Compiling BusyBox (Static)..."
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc)

rm -rf ../rootfs
mkdir -p ../rootfs
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- CONFIG_PREFIX=../rootfs install
cd ..

echo ">>> Setting up RootFS base directories..."
cd rootfs
mkdir -p proc sys dev root etc usr/bin usr/sbin lib/modules

# 2. Extract Kernel Version
cd "$DEPENDENCY_DIR/linux"
KERNEL_VERSION=$(cat include/config/kernel.release)
echo ">>> Detected Kernel Version: $KERNEL_VERSION"

# 3. Install Standard Kernel Modules into RootFS
echo ">>> Installing standard kernel modules..."
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH="$DEPENDENCY_DIR/rootfs" modules_install

# 4. Compile and Register Custom LKM
echo ">>> Compiling Custom LKM (WS_kernel_module)..."
cd "$WORKSPACE_DIR/WS_kernel_module"

#DIR="/workspaces/vsCode_Arm/WS_kernel_module"
#cd $DIR
make -C "$DEPENDENCY_DIR/linux" M="$(pwd)" ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- clean
make -C "$DEPENDENCY_DIR/linux" M="$(pwd)" ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules

echo ">>> Copying custom module into rootfs module path..."
# Place it neatly inside the kernel's module structure
mkdir -p "$DEPENDENCY_DIR/rootfs/lib/modules/$KERNEL_VERSION/kernel/drivers/misc"
cp my_module.ko "$DEPENDENCY_DIR/rootfs/lib/modules/$KERNEL_VERSION/kernel/drivers/misc/"

# 5. Run depmod to register modules in the filesystem (generates modules.dep)
echo ">>> Generating module dependency files (depmod)..."
depmod -b "$DEPENDENCY_DIR/rootfs" "$KERNEL_VERSION" || echo ">>> Note: Host depmod warning ignored, modules copied."

# 6. Create Init Script with automatic module loading
echo ">>> Creating init script with driver registration..."
cd "$DEPENDENCY_DIR/rootfs"
cat << 'EOF' > init
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev || mdev -s

echo "=== Loading Kernel Modules ==/n"
depmod -a
modprobe my_module || insmod /lib/modules/*/kernel/drivers/misc/my_module.ko

echo "=== ARM Linux Booted Successfully ==="
exec /bin/sh
EOF
chmod +x init
cd "$DEPENDENCY_DIR"

# 7. Generate Final CPIO Archive
echo ">>> Generating rootfs.cpio.gz archive..."
cd rootfs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > "$DEPENDENCY_DIR/rootfs.cpio.gz"
cd ..

echo "=================================================="
echo " BusyBox, RootFS & LKM integration complete!"
echo "=================================================="