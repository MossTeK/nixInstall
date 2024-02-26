#!/run/current-system/sw/bin/bash

# Partitioning the disk using parted
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MB -8GB
parted /dev/sda -- set 1 boot on
parted /dev/sda -- mkpart primary linux-swap -8GB 100%

# Check if partitioning was successful
if [[ $? -ne 0 ]]; then
    echo "Error: Partitioning /dev/sda failed."
    exit 1
fi

# Format the partitions
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
swapon /dev/sda2

# Check if formatting was successful
if [[ $? -ne 0 ]]; then
    echo "Error: Formatting partitions failed."
    exit 1
fi

# Mount the root partition
mount /dev/disk/by-label/nixos /mnt

# Generate NixOS configuration
nixos-generate-config --root /mnt

# declare grub boot device
sed -i 's/# boot.loader.grub.device = "\/dev\/sda"; # or "nodev" for efi only/boot.loader.grub.device = "\/dev\/sda";/' /mnt/etc/nixos/configuration.nix

# Install NixOS
nixos-install

if [ $? -eq 0 ]; then
    echo "nixos-install was successful"
else
    echo "nixos-install failed"
    exit 1
fi

#add home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

#curling configuration.nix
curl https://raw.githubusercontent.com/MossTeK/nixosConfig/main/nix/configuration.nix > /mnt/etc/nixos/configuration.nix

#reboot nix instance
sudo reboot