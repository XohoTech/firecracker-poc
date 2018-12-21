#!/usr/bin/env bash

# download rootfs
curl -fsSL -o dotnet-rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/hello/fsfiles/hello-rootfs.ext4

# resize ext4 volume
sudo e2fsck -f ./dotnet-rootfs.ext4
sudo resize2fs ./dotnet-rootfs.ext4 256M

# mount
mkdir custom-rootfs
sudo mount ./dotnet-rootfs.ext4 ./custom-rootfs

# get APK dependencies
mkdir apkroot
cd apkroot

curl -fsSL -o apk-tools-static-2.10.1-r0.apk http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/apk-tools-static-2.10.1-r0.apk
tar -xzf apk-tools-static-2.10.1-r0.apk

sudo ./sbin/apk.static -X http://dl-cdn.alpinelinux.org/alpine/v3.8/main --allow-untrusted --root ./root/ --initdb add libgcc
sudo ./sbin/apk.static -X http://dl-cdn.alpinelinux.org/alpine/v3.8/main --allow-untrusted --root ./root/ add libstdc++
sudo ./sbin/apk.static -X http://dl-cdn.alpinelinux.org/alpine/v3.8/main --allow-untrusted --root ./root/ add libintl

cd ..

sudo cp -afv  ./apkroot/root/lib/lib* ./custom-rootfs/lib/
sudo cp -afv  ./apkroot/root/usr/lib/lib* ./custom-rootfs/usr/lib/

mkdir dotnet
cd dotnet

# curl -fsSL -o dotnet-runtime-2.2.0.tar.gz https://download.visualstudio.microsoft.com/download/pr/6bb6c059-a9fe-44ad-9f9e-12027c858253/2742ebd7660077902e4a5f3f85d156c7/dotnet-runtime-2.2.0-linux-musl-x64.tar.gz
curl -fsSL -o dotnet-runtime-2.2.0-asp.net.tar.gz  https://download.visualstudio.microsoft.com/download/pr/60655cf9-5d19-4146-ac65-7ce8a23b5a4b/4393f9d9c5ebe85a2e27d83f500a6562/aspnetcore-runtime-2.2.0-linux-musl-x64.tar.gz


cd ..

sudo mkdir ./custom-rootfs/usr/share/dotnet

sudo tar -zxvf ./dotnet/dotnet-runtime-2.2.0-asp.net.tar.gz -C ./custom-rootfs/usr/share/dotnet/
sudo ln -fs /usr/share/dotnet/dotnet ./custom-rootfs/usr/bin/dotnet

# unmount
sudo umount ./custom-rootfs