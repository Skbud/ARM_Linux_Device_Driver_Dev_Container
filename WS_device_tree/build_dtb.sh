#!/bin/bash
set -e

# Define paths relative to script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
KERNEL_DIR="$WORKSPACE_DIR/dependency/linux"
DTS_NAME="custom_sabrelite"

echo "=================================================="
echo " Building Custom Device Tree: $DTS_NAME.dtb"
echo "=================================================="

# 1. Determine kernel DTS source directory for i.MX6
# Modern kernels place them in arch/arm/boot/dts/nxp/imx/
if [ -d "$KERNEL_DIR/arch/arm/boot/dts/nxp/imx" ]; then
    KERNEL_DTS_DIR="$KERNEL_DIR/arch/arm/boot/dts/nxp/imx"
    MAKEFILE_PATH="$KERNEL_DTS_DIR/Makefile"
else
    KERNEL_DTS_DIR="$KERNEL_DIR/arch/arm/boot/dts"
    MAKEFILE_PATH="$KERNEL_DTS_DIR/Makefile"
fi

# 2. Copy custom DTS into kernel source tree
echo ">>> Copying custom DTS into kernel tree..."
cp "$SCRIPT_DIR/$DTS_NAME.dts" "$KERNEL_DTS_DIR/"

# 3. Ensure the Makefile in the kernel DTS folder knows about your custom dtb
if ! grep -q "$DTS_NAME.dtb" "$MAKEFILE_PATH"; then
    echo ">>> Registering $DTS_NAME.dtb in kernel Makefile..."
    # Append it to the dtb-y list for i.MX6
    echo "dtb-\$(CONFIG_SOC_IMX6Q) += $DTS_NAME.dtb" >> "$MAKEFILE_PATH"
fi

# 4. Compile the Device Tree using the kernel build system
echo ">>> Compiling dtbs..."
cd "$KERNEL_DIR"
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs

# 5. Locate and copy the generated DTB to WS_Device_tree/build/
echo ">>> Copying compiled DTB to WS_device_tree/build/..."
if [ -f "$KERNEL_DTS_DIR/$DTS_NAME.dtb" ]; then
    cp "$KERNEL_DTS_DIR/$DTS_NAME.dtb" "$SCRIPT_DIR/build/"
else
    # Fallback search if path differs
    find arch/arm/boot/dts -name "$DTS_NAME.dtb" -exec cp {} "$SCRIPT_DIR/build/" \;
fi

echo "=================================================="
echo " Success! Custom DTB placed at: WS_device_tree/build/$DTS_NAME.dtb"
echo "=================================================="