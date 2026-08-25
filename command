26  uname -m
  127  cat /etc/os-release
  128  lscpu | grep -E 'Architecture|Virtualization|Model name|CPU\(s\)'
  129  sudo apt update
  130  sudo apt install -y     qemu-system-arm     qemu-utils     qemu-efi-aarch64     qemu-system-misc     gcc     g++     make     git     cmake     ninja-build     python3     python3-pip     bc     bison     flex     libssl-dev     libelf-dev     device-tree-compiler     u-boot-tools
  131  qemu-system-aarch64 --version
  132  ls -l /dev/kvm
  133  mkdir -p ~/r3n-phone/{build,images,kernel,firmware,tools}
  134  cd ~/r3n-phone
  135  ls
  136  qemu-system-aarch64 --version
  137  ls -l /dev/kvm
  138  test -r /dev/kvm && echo "KVM available" || echo "KVM unavailable"
  139  cat ~/r3n-phone/device.conf
  140  cat > device.conf <<'EOF'
NAME=r3n-phone
ARCH=aarch64
CPUS=4
RAM=4096
STORAGE=62G
MACHINE=virt
EOF

  141  cat device.conf
  142  mkdir -p images
  143  qemu-img create -f qcow2 images/userdata.qcow2 62G
  144  qemu-img info images/userdata.qcow2
  145  curl -fsSL https://antigravity.google/cli/install.sh | bash
  146  history
  147  clear
  148  qemu-system-aarch64 --version
  149  qemu-system-aarch64 -machine help | head -20
  150  qemu-system-aarch64 -machine help | grep -E '^virt'
  151  sudo apt update
  152  sudo apt install -y linux-image-arm64
  153  sudo dpkg --add-architecture arm64
  154  sudo apt update
  155  dpkg --print-foreign-architectures
  156  apt-cache policy linux-image-arm64:arm64
  157  sudo apt install linux-image-arm64:arm64
  158  file /boot/vmlinuz-6.12.101+deb13-arm64
  159  cd ~/r3n-phone
  160  cp /boot/vmlinuz-6.12.101+deb13-arm64 kernel/
  161  cp /boot/initrd.img-6.12.101+deb13-arm64 kernel/
  162  ls -lh kernel/
  163  qemu-system-aarch64 -machine help | grep '^virt'
  164  qemu-system-aarch64   -machine virt   -cpu cortex-a76   -smp 4   -m 4096   -kernel kernel/vmlinuz-6.12.101+deb13-arm64   -initrd kernel/initrd.img-6.12.101+deb13-arm64   -append "console=ttyAMA0 earlycon"   -nographic
sudo apt install -y debootstrap
cd ~/r3n-phone
sudo debootstrap \
  --arch=arm64 \
  --foreign \
  trixie \
  rootfs \
  http://deb.debian.org/debian
 169  cd ~/r3n-phone
  170  ls -lh kernel/
  171  sudo apt install -y debootstrap
  172  cd ~/r3n-phone
  173  sudo debootstrap   --arch=arm64   --foreign   trixie   rootfs   http://deb.debian.org/debian
  174  file rootfs/bin/sh
  175  file rootfs/bin/dash
  176  sudo apt install -y qemu-user-static binfmt-support
  177  ls -l /usr/bin/qemu-aarch64-static
  178  sudo cp /usr/bin/qemu-aarch64-static rootfs/usr/bin/
  179  sudo chroot rootfs /debootstrap/debootstrap --second-stage
  180  sudo chroot rootfs /usr/bin/uname -m
  184  sudo chroot rootfs /usr/bin/uname -m
  185  cd ~/r3n-phone
  186  sudo tee rootfs/etc/hostname >/dev/null <<'EOF'
r3n-phone
EOF

  187  sudo tee rootfs/etc/fstab >/dev/null <<'EOF'
/dev/vda / ext4 defaults 0 1
EOF

  188  qemu-img create -f raw images/rootfs.img 8G
  189  mkfs.ext4 -F images/rootfs.img
191  mkfs.ext4 -F images/rootfs.img
  192  sudo apt update
  193  sudo apt install -y e2fsprogs
  194  mkfs.ext4 -V
  195  sudo /usr/sbin/mkfs.ext4 -V
  196  cd ~/r3n-phone
  197  sudo /usr/sbin/mkfs.ext4 -F images/rootfs.img
  198  sudo mkdir -p /mnt/r3n-rootfs
  199  sudo mount -o loop images/rootfs.img /mnt/r3n-rootfs
  200  sudo cp -a rootfs/. /mnt/r3n-rootfs/
  201  sudo umount /mnt/r3n-rootfs
  202  ls -lh images/rootfs.img
  203  dpkg -L e2fsprogs | grep '/mkfs.ext4$'
  204  cd ~/r3n-phone
  205  qemu-system-aarch64   -machine virt   -cpu cortex-a76   -smp 4   -m 4096   -kernel kernel/vmlinuz-6.12.101+deb13-arm64   -append "root=/dev/vda rw console=ttyAMA0"   -drive file=images/rootfs.img,format=raw,if=virtio   -nographic
  206  cd ~/r3n-phone
  207  grep -E 'CONFIG_VIRTIO(_BLK)?=' /boot/config-$(uname -r)
  208  grep -E 'CONFIG_VIRTIO(_BLK)?=' kernel/config-* 2>/dev/null
  209  ls -lh /boot/initrd*
  210  ls /lib/modules/$(uname -r)/
  211  sudo modinfo virtio_blk | head -20
  212  sudo update-initramfs -c -k 6.12.101+deb13-arm64
  213  ls -lh /boot/initrd*
  214  ls /lib/modules/$(uname -r)/
  215  cd ~/r3n-phone
  216  cp /boot/initrd.img-6.12.101+deb13-arm64 kernel/initrd.img
  217  ls -lh kernel/initrd.img
  218  lsinitramfs kernel/initrd.img | grep virtio_blk
  219  lsinitramfs kernel/initrd.img | grep -E 'virtio(_blk|_pci)'
  220  cd ~/r3n-phone
  221  qemu-system-aarch64   -machine virt   -cpu cortex-a76   -smp 4   -m 4096   -kernel kernel/vmlinuz-6.12.101+deb13-arm64   -initrd kernel/initrd.img   -append "root=/dev/vda rw console=ttyAMA0"   -drive file=images/rootfs.img,format=raw,if=virtio   -nographic
  222  cd ~/r3n-phone
  223  sudo losetup -Pf --show images/rootfs.img
  224  sudo mount /dev/loop0p1 /mnt
  225  file /mnt/bin/sh
  226  file /mnt/sbin/init
  227  file /mnt/lib/systemd/systemd 2>/dev/null
  228  sudo mount /dev/loop0 /mnt
  229  file /mnt/bin/sh
  230  file /mnt/sbin/init
  231  file /mnt/lib/systemd/systemd 2>/dev/null
  232  sudo ls -lh /mnt/

