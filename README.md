# r3n-phone ARM64 QEMU Boot Setup

This repository contains the configuration, build scripts, and guides for booting the custom ARM64 Linux rootfs image (`r3n-phone`) with QEMU AArch64.

## System Overview
- **Host**: Linux x86_64
- **Target**: ARM64 / AArch64
- **Machine**: `virt`
- **CPU**: `cortex-a76`
- **RAM**: 4096 MB
- **Kernel**: `6.12.101+deb13-arm64` (Modular kernel)
- **Rootfs**: `images/rootfs.img` (8.0 GB ext4 partition)

---

## 🛠️ The Boot Troubles & Solutions

### Issue 1: `Failed to execute /init (error -8)`
* **Diagnosis:** The Linux kernel failed with `ENOEXEC` (Exec format error). The initial initramfs provided was compiled for x86_64 (or contained non-AArch64 binaries) causing `binfmt-464c` modprobe errors as the kernel repeatedly attempted to find an interpreter for the mismatched ELF architecture.
* **Solution:** Build a clean, minimal, custom initramfs containing only a genuine static ARM64 BusyBox executable and a correct `/init` shell script.

### Issue 2: Modular block device & filesystem drivers
* **Diagnosis:** After building a minimal initramfs, QEMU hung because `/dev/vda` was never found. Checking the kernel config `/boot/config-6.12.101+deb13-arm64` revealed:
  ```ini
  CONFIG_VIRTIO_BLK=m
  CONFIG_EXT4_FS=m
  CONFIG_CRYPTO_CRC32C=m
  CONFIG_LIBCRC32C=m
  ```
  Since `virtio_blk` and `ext4` are modules (`=m`) rather than built-in (`=y`), the kernel cannot talk to the virtio disk or mount the root partition without loading these modules from the initramfs.
* **Solution:** Extract the modules and their dependencies (`crc16`, `mbcache`, `jbd2`, `libcrc32c`, `crc32c_generic`) from the host's `/lib/modules/` directory, place them inside the initramfs, and load them using `insmod` inside `/init` prior to mounting.

---

## 📂 Repository Contents
* `device.conf`: Device configuration parameters (RAM, CPUs, machine name).
* `build-initramfs.sh`: Automates building the custom initramfs, copying the static ARM64 BusyBox, copying modular kernel drivers, and packing it.
* `run-qemu.sh`: A runner script to boot the ARM64 virtual machine using QEMU with console redirect.
* `.gitignore`: Excludes large image files, modules, and transient files from being committed.

---

## 🚀 Step-by-Step Instructions

### 1. Prerequisite: Download ARM64 Static BusyBox
If not already present at `tmp/usr/bin/busybox`, fetch and unpack it:
```bash
sudo dpkg --add-architecture arm64 && sudo apt-get update -y
mkdir -p tmp && cd tmp
apt-get download busybox-static:arm64
ar x busybox-static_*.deb
tar -xf data.tar.xz
cd ..
```

### 2. Build the Initramfs
Run the build script to pack the initramfs with BusyBox and the kernel modules:
```bash
./build-initramfs.sh
```
This generates the initrd file at `kernel/initrd-r3n-arm64.img` (approx 1.5 MB).

### 3. Setting the Root Password
Since default `debootstrap` installs a locked root account, you must set a password by mounting the rootfs image locally on the host:
```bash
sudo mount -o loop images/rootfs.img /mnt
sudo chroot /mnt passwd root
sudo umount /mnt
```

### 4. Boot with QEMU
Start the ARM64 virtual machine:
```bash
./run-qemu.sh
```
To exit the serial console, press `Ctrl + A` then `X`.
