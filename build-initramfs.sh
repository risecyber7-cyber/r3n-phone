#!/bin/bash
set -e

PROJECT_DIR="/home/zenr3n/r3n-phone"
INITRD_DIR="/home/zenr3n/r3n-phone/initramfs"
KERNEL_VERSION="6.12.101+deb13-arm64"

echo "=== Preparing clean initramfs directories ==="
rm -rf "$INITRD_DIR"
mkdir -p "$INITRD_DIR"/{bin,sbin,proc,sys,dev,newroot,lib/modules/$KERNEL_VERSION}

echo "=== Copying BusyBox and symlinks ==="
# Copy static busybox from our verified downloaded package location
cp "$PROJECT_DIR/tmp/usr/bin/busybox" "$INITRD_DIR/bin/"
chmod +x "$INITRD_DIR/bin/busybox"

for app in sh mount umount switch_root pivot_root; do
    ln -sf busybox "$INITRD_DIR/bin/$app"
done

echo "=== Copying required kernel modules ==="
# Since virtio_blk and ext4 are modules (=m) in the kernel config, we must include them
# along with their dependencies (crc16, mbcache, jbd2, crc32c) in the initramfs.
MODULES=(
    "kernel/lib/crc16.ko.xz"
    "kernel/fs/mbcache.ko.xz"
    "kernel/fs/jbd2/jbd2.ko.xz"
    "kernel/fs/ext4/ext4.ko.xz"
    "kernel/drivers/block/virtio_blk.ko.xz"
    "kernel/lib/libcrc32c.ko.xz"
    "kernel/crypto/crc32c_generic.ko.xz"
)

for mod in "${MODULES[@]}"; do
    src="/lib/modules/$KERNEL_VERSION/$mod"
    if [ -f "$src" ]; then
        cp "$src" "$INITRD_DIR/lib/modules/$KERNEL_VERSION/"
    else
        echo "Error: Module $src not found!"
        exit 1
    fi
done

echo "=== Decompressing kernel modules ==="
xz -d "$INITRD_DIR/lib/modules/$KERNEL_VERSION"/*.xz

echo "=== Writing the /init script ==="
cat > "$INITRD_DIR/init" <<'SUBEOF'
#!/bin/busybox sh
# Minimal init for the r3n‑phone image with kernel module loading

# mount the essential pseudo‑filesystems
mount -t proc  proc  /proc
mount -t sysfs sys   /sys
mount -t devtmpfs dev  /dev

# Load crypto and filesystem libraries/drivers
insmod /lib/modules/6.12.101+deb13-arm64/crc32c_generic.ko
insmod /lib/modules/6.12.101+deb13-arm64/libcrc32c.ko
insmod /lib/modules/6.12.101+deb13-arm64/crc16.ko
insmod /lib/modules/6.12.101+deb13-arm64/mbcache.ko
insmod /lib/modules/6.12.101+deb13-arm64/jbd2.ko
insmod /lib/modules/6.12.101+deb13-arm64/ext4.ko
insmod /lib/modules/6.12.101+deb13-arm64/virtio_blk.ko

# wait for the virtio block device that QEMU presents as /dev/vda
while [ ! -b /dev/vda ]; do
    sleep 1
done

# mount the real root read‑only first; we will switch to rw after pivot
mount -t ext4 -o ro /dev/vda /newroot

# hand over to the real rootfs
exec switch_root /newroot /sbin/init
SUBEOF

chmod +x "$INITRD_DIR/init"

echo "=== Packaging the initramfs ==="
cd "$INITRD_DIR"
find . | cpio -H newc -o | gzip -9 > "$PROJECT_DIR/kernel/initrd-r3n-arm64.img"

echo "=== Verification ==="
echo "Initrd packed successfully at $PROJECT_DIR/kernel/initrd-r3n-arm64.img"
ls -lh "$PROJECT_DIR/kernel/initrd-r3n-arm64.img"
