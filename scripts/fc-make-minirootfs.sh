#!/usr/bin/env bash

# download Alpine 3.8.1 mini rootfs
curl -fsSL -o alpine-minirootfs-3.8.1-x86_64.tar.gz  http://dl-cdn.alpinelinux.org/alpine/v3.8/releases/x86_64/alpine-minirootfs-3.8.1-x86_64.tar.gz

# make new ext4 volume
mkfs.ext4 -t ext4 ./alpine-mini-rootfs.ext4 256M

# mount
mkdir custom-rootfs
sudo mount ./alpine-mini-rootfs.ext4 ./custom-rootfs

# fill up files to the volume
sudo tar -xvf ./alpine-minirootfs-3.8.1-x86_64.tar.gz -C ./custom-rootfs/

# unmount
sudo umount ./custom-rootfs