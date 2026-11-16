#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "===================================================="
echo " Starting Full SABRE Lite Environment Build Pipeline"
echo "===================================================="

# Ensure execution permissions
chmod +x "$SCRIPT_DIR/build_uboot.sh"
chmod +x "$SCRIPT_DIR/build_linux.sh"
chmod +x "$SCRIPT_DIR/build_busybox_rootfs.sh"

# Execute sequentially
"$SCRIPT_DIR/build_uboot.sh"
"$SCRIPT_DIR/build_linux.sh"
"$SCRIPT_DIR/build_busybox_rootfs.sh"

echo "=========================================================================="
echo " All build pipelines finished successfully!"
echo " Check 'dependency/' for u-boot, linux, and busybox sources and artifacts."
echo "=========================================================================="