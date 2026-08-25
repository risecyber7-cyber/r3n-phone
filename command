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
236  clear
  237  file /mnt/usr/lib/aarch64-linux-gnu/ld-linux-aarch64.so.1
  238  ls -l /mnt/lib/ld-linux-aarch64.so.1
  239  ls -l /mnt/usr/lib/systemd/systemd
  240  file /mnt/usr/bin/dash
  241  ls -l /mnt/usr/lib/aarch64-linux-gnu/ | head
  242  findmnt /mnt
  243  sudo blkid /dev/loop0
  244  sudo update-initramfs -c -k 6.12.101+deb13-arm64
  245  lsinitramfs kernel/initrd.img | head -50
  246  lsinitramfs kernel/initrd.img | grep -E '(^|/)(init|systemd|busybox|modprobe)$' | head -30
  247  ls -lh kernel/initrd.img
  248  file kernel/initrd.img
  249  ls -lh /boot/initrd.img-6.12.101+deb13-arm64
  250  clean
  251  cleaN
  252  clean
  253  clear
  254  sudo umount /mnt
  255  sudo losetup -d /dev/loop0
  256  sudo cp /boot/initrd.img-6.12.101+deb13-arm64 kernel/initrd.img
  257  sudo chown zenr3n:zenr3n kernel/initrd.img
  258  ls -lh kernel/initrd.img
  259  lsinitramfs kernel/initrd.img | grep 'x86_64-linux-gnu/systemd'
  260  lsinitramfs kernel/initrd.img | grep -E 'usr/lib/(aarch64-linux-gnu|arm64-linux-gnu)/systemd|usr/lib/systemd'
  261  lsinitramfs kernel/initrd.img | head -30
  262  mkdir -p /tmp/r3n-initrd
  263  cd /tmp/r3n-initrd
  264  zcat ~/r3n-phone/kernel/initrd.img 2>/dev/null | cpio -it 2>/dev/null | grep '^init$'
  265  lsinitramfs ~/r3n-phone/kernel/initrd.img | grep '^init$'
  266  cd ~/r3n-phone
  267  qemu-system-aarch64   -machine virt   -cpu cortex-a76   -smp 4   -m 4096   -kernel kernel/vmlinuz-6.12.101+deb13-arm64   -initrd kernel/initrd.img   -append "root=/dev/vda rw console=ttyAMA0"   -drive file=images/rootfs.img,format=raw,if=virtio   -nographic
  268  cd ~/r3n-phone
  269  mkdir -p /tmp/check-initrd
  270  cd /tmp/check-initrd
  271  zcat ~/r3n-phone/kernel/initrd.img 2>/dev/null | cpio -idmu 2>/dev/null ||   cpio -idmu < ~/r3n-phone/kernel/initrd.img
  272  file init
  273  file usr/bin/busybox 2>/dev/null
  274  file usr/sbin/init 2>/dev/null
  275  file usr/lib/x86_64-linux-gnu/systemd 2>/dev/null
  276  file usr/lib/aarch64-linux-gnu/systemd 2>/dev/null
  277  cd ~/r3n-phone
  278  sudo umount /mnt 2>/dev/null || true
  279  sudo mount /dev/loop0 /mnt
  280  cd ~/r3n-phone
  281  rm -rf /tmp/r3n-initrd
  282  mkdir -p /tmp/r3n-initrd
  283  sudo cp /mnt/usr/bin/busybox bin/busybox
  284  sudo chmod +x bin/busybox
  285  sudo nano /tmp/r3n-initrd/init
  286  /tmp/r3n-initrd/bin/busybox switch_root --help
  287  cd /tmp/r3n-initrd
  288  sudo find . -print0 | sudo cpio --null -o -H newc | gzip -9 > ~/r3n-phone/kernel/initrd-r3n-arm64.img
  289  ls -lh ~/r3n-phone/kernel/initrd-r3n-arm64.img
  290  mkdir -p /tmp/check-new-initrd
  291  cd /tmp/check-new-initrd
  292  zcat ~/r3n-phone/kernel/initrd-r3n-arm64.img | cpio -it | head -30
  293  rm -rf /tmp/check-new-initrd/*
  294  zcat ~/r3n-phone/kernel/initrd-r3n-arm64.img | cpio -idmu\
  295  file init
  296  file bin/busybox
  297  rm -rf /tmp/r3n-initrd
  298  mkdir -p /tmp/r3n-initrd
  299  /boot/initrd.img-6.12.101+deb13-arm64
  300  cd /tmp/r3n-initrd
  301  sudo sh -c 'zcat /boot/initrd.img-6.12.101+deb13-arm64 | cpio -idm'
  302  ls -lh usr/bin/busybox
  303  file usr/bin/busybox
  304  find usr -name busybox -type f -ls
  305  sudo mkdir -p /tmp/r3n-initrd/bin
  306  sudo ln -sf ../usr/bin/busybox /tmp/r3n-initrd/bin/busybox
  307  ls -l /tmp/r3n-initrd/bin/busybox
  308  file /tmp/r3n-initrd/usr/bin/busybox
  309  sudo nano /tmp/r3n-initrd/init
  310  sudo chmod +x /tmp/r3n-initrd/init
  311  ls -l /tmp/r3n-initrd/init
  312  ls -l /tmp/r3n-initrd/bin/busybox
  313  ls -l /tmp/r3n-initrd/usr/bin/busybox
  314  file /tmp/r3n-initrd/usr/bin/busybox
  315  cd /tmp/r3n-initrd
  316  sudo find . -print0 | sudo cpio --null -o -H newc | gzip -9 > ~/r3n-phone/kernel/initrd-r3n-arm64.img
  317  ls -lh ~/r3n-phone/kernel/initrd-r3n-arm64.img
  318  zcat ~/r3n-phone/kernel/initrd-r3n-arm64.img | cpio -it | grep -E '(^|/)(init|busybox)$' | head
  319  mkdir -p /tmp/check-new-initrd
  320  cd /tmp/check-new-initrd
  321  zcat ~/r3n-phone/kernel/initrd-r3n-arm64.img | cpio -idmu
  322  file init
  323  file usr/bin/busybox
  324  ls -l bin/busybox
  325  qemu-system-aarch64   -machine virt   -cpu cortex-a76   -smp 4   -m 4096   -kernel kernel/vmlinuz-6.12.101+deb13-arm64   -initrd kernel/initrd-r3n-arm64.img   -append "root=/dev/vda rw console=ttyAMA0"   -drive file=images/rootfs.img,format=raw,if=virtio   -nographic
  326  file /boot/initrd.img-6.12.101+deb13-arm64
  327  ls -lh /boot/initrd.img-6.12.101+deb13-arm64
  328  sudo cpio -it < /boot/initrd.img-6.12.101+deb13-arm64 | grep -E '(^|/)(busybox|init)$' | head -30
  329  sudo cpio -it < /boot/initrd.img-6.12.101+deb13-arm64 | head -30
  330  cd ~/r3n-phone
  331  ls -lh images/rootfs.img
  332  ls -lh kernel/vmlinuz-6.12.101+deb13-arm64
sudo dpkg --add-architecture arm64 && sudo apt-get update -y
apt-get download busybox-static:arm64
   mkdir -p /home/zenr3n/r3n-phone/tmp && cd /home/zenr3n/r3n-phone/tmp && apt-get download busybox-static:arm64
   cd /home/zenr3n/r3n-phone/tmp && ar x busybox-static_*.deb && tar -xf data.tar.xz -C .
   file /home/zenr3n/r3n-phone/tmp/bin/busybox
   ls -R /home/zenr3n/r3n-phone/tmp | head -n 40
● Bash(cp /home/zenr3n/r3n-phone/tmp/usr/bin/busybox /home/zenr3n/r3n-phone/initramfs/bin/) (ctrl+o to expand)
   cp /home/zenr3n/r3n-phone/tmp/usr/bin/busybox /home/zenr3n/r3n-phone/initramfs/bin/
● Bash(mkdir -p /home/zenr3n/r3n-phone/initramfs && rm -rf /home/zenr3n/r3n-phone/initramfs/
   for app in sh mount umount pivot_root switch_root; do ln -s busybox /home/zenr3n/r3n-phone/initramfs/bin/$app; done



## 6⃣ Create the init script (the first program the kernel runs)

    cat > /home/zenr3n/r3n-phone/initramfs/init <<'EOF'
    #!/bin/busybox sh
    # Minimal init for the r3n‑phone image
    
    # mount the essential pseudo‑filesystems
    mount -t proc  proc  /proc
    mount -t sysfs sys   /sys
    mount -t devtmpfs dev  /dev
    
    # wait for the virtio block device that QEMU presents as /dev/vda
    while [ ! -b /dev/vda ]; do
        sleep 1
    done
    
    # mount the real root read‑only first; we will switch to rw after pivot
    mount -t ext4 -o ro /dev/vda /newroot
    
    # hand over to the real rootfs
    exec switch_root /newroot /sbin/init
    EOF
  Make it executable:
    chmod +x /home/zenr3n/r3n-phone/initramfs/init
  ──────
  ## 7⃣ Pack the initramfs (cpio + gzip)
    cd /home/zenr3n/r3n-phone/initramfs
    # create a newc CPIO archive and gzip it – exactly what the kernel expects
    find . | cpio -H newc -o | gzip -9 > /home/zenr3n/r3n-phone/kernel/initrd-r3n-arm64.img

  The resulting file should be only a few kilobytes (≈ 10 KB).
  ──────
  ## 8⃣ Verify the archive before booting

  ### 8.1 List its contents
    gzip -dc /home/zenr3n/r3n-phone/kernel/initrd-r3n-arm64.img | cpio -t --format=newc
  You should see at least:

    ./
    ./bin/
    ./bin/busybox
    ./bin/sh
    ./bin/mount
    ./bin/umount
    ./bin/pivot_root
    ./bin/switch_root
    ./init
    ./dev/
    ./proc/
    ./sys/
    ./newroot/
  ### 8.2 Confirm the BusyBox binary is ARM64

    gzip -dc /home/zenr3n/r3n-phone/kernel/initrd-r3n-arm64.img | \
      cpio -i --to-stdout ./bin/busybox | file -
  Expected output (the exact version may differ but must contain ARM aarch64):

    /dev/stdin: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, stripped

  If any entry shows a different architecture or is missing, stop and let me know.
  ──────
  ## 9⃣ Final QEMU command (all absolute paths)
    /home/zenr3n/r3n-phone/qemu-system-aarch64 \
      -machine virt \
      -cpu cortex-a76 \
      -smp 4 \
      -m 4096 \
      -kernel /home/zenr3n/r3n-phone/kernel/vmlinuz-6.12.101+deb13-arm64 \
      -initrd /home/zenr3n/r3n-phone/kernel/initrd-r3n-arm64.img \
      -append "root=/dev/vda rw console=ttyAMA0" \
      -drive file=/home/zenr3n/r3n-phone/images/rootfs.img,format=raw,if=virtio \
      -nographic

  • root=/dev/vda points the kernel to the virtio disk you already provide.
  • The initramfs will mount that disk at /newroot, then switch_root to it and finally run /sbin/init from the
  already‑validated ARM64 rootfs.
