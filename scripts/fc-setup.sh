#!/usr/bin/env bash

# get & setup binary
curl -LOJ https://github.com/firecracker-microvm/firecracker/releases/download/v0.12.0/firecracker-v0.12.0
mv firecracker-v0.12.0 firecracker
chmod +x ./firecracker
sudo mv ./firecracker /usr/local/bin/
firecracker --version

# ensure access to KVM (after each reboot)
sudo setfacl -m u:${USER}:rw /dev/kvm
