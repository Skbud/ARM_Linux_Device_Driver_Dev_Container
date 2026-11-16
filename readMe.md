# ARM Linux & Device Driver Dev Container Lab

A portable, fully reproducible development environment designed for learning and experimenting with **Linux Kernel Modules (LKMs)**, **Device Trees (DTS)**, and embedded Linux bring-up using the **QEMU's Boundary Devices SABRE Lite (i.MX6)** virtual platform.

---

## 🚀 Key Features
- **Zero-Hassle Setup:** Powered by VS Code Dev Containers—no need to manually configure cross-compilers or toolchains on your host machine.
- **Automated Build Pipeline:** Automatically compiles U-Boot, the Linux Kernel, a static BusyBox rootfs (`rootfs.cpio.gz`), and standard/custom kernel modules on first run.
- **Isolated Customizations:** Clean separation for custom device trees (`WS_Device_tree`) and loadable kernel modules (`WS_kernel_module`).
- **QEMU Emulation Ready:** Test your custom kernel, modules, and device tree instantly inside QEMU.

---

## 📂 Project Directory Structure

```text
.
├── .devcontainer/                # Dev Container setup and automated build pipelines
│   ├── devcontainer.json         # Container configuration
│   ├── Dockerfile                # Environment definition
│   ├── build_uboot.sh            # U-Boot build script
│   ├── build_linux.sh            # Linux kernel & modules build script
│   ├── build_busybox_rootfs.sh   # Static BusyBox, RootFS & LKM integration script
│   └── buildQemuDeviceSetup.sh   # QEMU setup/automation helper
├── .vscode/                      # VS Code workspace settings and tasks
│   ├── c_cpp_properties.json     # IntelliSense configuration for kernel headers
│   ├── tasks.json                # Custom VS Code build tasks for LKM
│   └── vscode.readme.md          # Guide for using VS Code tasks
├── dependency/                   # Cloned source trees, rootfs, and compiled artifacts (Git-ignored)
│   ├── busybox/                  # BusyBox source tree
│   ├── linux/                    # Linux kernel source tree
│   ├── u-boot/                   # U-Boot source tree
│   ├── rootfs/                   # Target root filesystem tree
│   ├── u-boot-bin                # Compiled U-Boot binary
│   ├── zImage                    # Compiled kernel binary
│   ├── rootfs.cpio.gz            # Initial RAM filesystem archive
│   └── imx6q-sabrelite.dtb       # Default device tree blob
├── WS_device_tree/               # Custom Device Tree source and build folder
│   ├── custom_sabrelite.dts      #  custom DTS file
│   ├── build_dtb.sh              # Build script for compiling custom DTB
│   ├── setup                     # Setup script
│   └── build/                    # Output folder for compiled custom .dtb
├── WS_kernel_module/             # Custom Loadable Kernel Module (LKM)
│   ├── my_module.c               
│   ├── Makefile                  
│  
├── test/
    └── runsteps.txt              # Execution log and step notes
```

## 🚀 Getting Started with Dev Containers
1. Clone the repository and open the workspace within VS Code
2. When prompted by VS Code, select **"Reopen in Container"** to spin up the development container equipped with the arm-linux-gnueabihf- toolchain.

3. Upon initialization, the build automation script (`.devcontainer/buildQemuDeviceSetup.sh`) automatically executes:
    - Clones and builds **U-Boot** (`u-boot-bin`).

    - Clones and builds the **Linux Kernel** (`zImage`, Device Tree, and standard modules).

    - Compiles a static **BusyBox** instance, constructs the `rootfs`, and registers module dependencies via `depmod`.

    - Generates the initial RAM filesystem archive (`rootfs.cpio.gz`).

## Kernel Module Workflow (`WS_kernel_module`)
Out-of-tree kernel modules are compiled directly against the kernel source tree located in `dependency/linux/`.

**Compilation via CLI (make)**
Navigate to the module directory and invoke the Makefile:
```bash
cd WS_kernel_module
make
```

**Compilation via VS Code Tasks (tasks.json)**
The workspace includes predefined tasks for building and cleaning the LKM:
1. Open the Command Palette (Ctrl+Shift+P / Cmd+Shift+P) or build directly with key bindings.

2. Run Tasks: Run Task.

3. Select either build: lkm or clean: lkm.

***Note**: Compiled objects and my_module.ko are automatically staged into the rootfs module tree (dependency/rootfs/lib/modules/...) during the broader pipeline execution.*

## Custom Device Tree Workflow (`WS_device_tree`)
To introduce custom hardware modifications or pin multiplexing overrides, manage device trees through the WS_device_tree subsystem.

### Sourcing and Setup
Copy a baseline DTS from the kernel source tree into your workspace or use the setup script
```bash
cd WS_device_tree
cp ../dependency/linux/arch/arm/boot/dts/nxp/imx/imx6q-sabrelite.dts custom_sabrelite.dts
```


### Compilation
The build script integrates custom DTS into the kernel's Kbuild infrastructure to properly resolve `#include` dependencies and macro paths:
```bash
./build_dtb.sh
```

The resulting compiled binary is automatically output to:`WS_device_tree/build/custom_sabrelite.dtb`

## 🧪 Target Emulation & Verification (QEMU)
Validate the integrated rootfs, custom LKM, and device tree via QEMU target emulation:

```bash
qemu-system-arm -M sabrelite -smp 4 -m 1G \
  -display none -serial null -serial stdio \
  -kernel zImage -dtb imx6q-sabrelite.dtb -initrd rootfs.cpio.gz \
  -append "root=/dev/ram rdinit=/init"
```


