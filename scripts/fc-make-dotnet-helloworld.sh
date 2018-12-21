#!/usr/bin/env bash

# mount
sudo mount ./dotnet-rootfs.ext4 ./custom-rootfs

# extract
sudo tar -zxf hello-world.tar.gz -C ./custom-rootfs/root/

# unmount
sudo umount ./custom-rootfs