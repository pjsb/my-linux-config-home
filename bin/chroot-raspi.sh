#!/bin/bash

echo "Inserting needed modules & start services"
modprobe virtio
modprobe virtio_pci
modprobe virtio_balloon
modprobe virtio_blk
modprobe virtio_console
modprobe virtio-rng
#(modprobe virtio_mmio)
/etc/init.d/libvirtd start

echo "Mounting SD Card"
mount /dev/mmcblk0p3 /mnt/gentoo/
mount /dev/mmcblk0p1 /mnt/gentoo/boot
cd /mnt/gentoo && chmod +x bin/bash

echo "Copy needed host files: qemu-wrapper & resolv.conf"
cp /usr/bin/qemu-arm /mnt/gentoo/usr/bin
cp /home/jens/raspberry/new/qemu-wrapper /mnt/gentoo/qemu-wrapper
cp -L /etc/resolv.conf /mnt/gentoo/etc/resolv.conf

echo "CHROOT - copy qemu"
#ROOT=$PWD/ emerge -K app-emulation/qemu

echo "CHROOT - mounting needed directories"
mount --bind /usr/portage usr/portage
mount --bind /proc proc
mount --bind /sys sys
mount --rbind /dev dev
#mount --bind /dev/pts dev/pts

echo "CHROOT - ENTER"
#(Chroot into the environment)
#chroot . /bin/busybox mdev -s
#chroot . /bin/bash --login
#chroot /mnt/gentoo /usr/bin/qemu-arm /bin/bash
chroot /mnt/gentoo /qemu-wrapper /bin/bash

#source /etc/profile
#env-update
#mkdir /run/shm
#export PS1="(raspi) - $PS1"
#uname -a
