#!/bin/bash
/usr/bin/qemu-system-aarch64 \
  -machine virt \
  -cpu cortex-a76 \
  -smp 4 \
  -m 4096 \
  -kernel /home/zenr3n/r3n-phone/kernel/vmlinuz-6.12.101+deb13-arm64 \
  -initrd /home/zenr3n/r3n-phone/kernel/initrd-r3n-arm64.img \
  -append "root=/dev/vda rw console=ttyAMA0" \
  -drive file=/home/zenr3n/r3n-phone/images/rootfs.img,format=raw,if=virtio \
  -nographic
