# NIXOS on QEMU/KVM Installation Script

This repository provides an installation script for deploying NIXOS on QEMU/KVM. The script serves as a template for configuring NIXOS as a "server". The intention is not to use the configuration as is, but to fork the repository and customize it for the specific service(s) you plan to host. The `configuration.nix` file is configured with minimal settings, and it is important to replace the default user "tek" with your own.

## Default Included Packages

The default set of packages included in the installation script are as follows:
- home-manager
- vim
- wget
- neofetch
- git
- lf

Feel free to modify the `configuration.nix` file to include or exclude packages according to your requirements.

## home-manager

we currently use `home-manager` for managing user specific configs (dot files, environment variables, aliases etc...). this is done using the `home.nix` you can find the home-manager documentation [here](https://nix-community.github.io/home-manager/)

## Partitioning Info

The installation script partitions the disk with a basic setup designed for legacy boot, not UEFI. The partitioning includes:

- 8GB swap partition
- EXT4 for the main partition

## startup.sh

this is a temporary script that will be depricated once my ansible setup is fully taken care of, and all my playbooks are written. all it does is clone a mirror of the nixpkgs repo so we can change anything we need to there, then it clones home.nix and configuration.nix. deployment is not automated due to how early the infra is in in its development stage, since I depricated all my current infra to rebuild from scratch. 

## Usage

You will want to curl this script as Nix dosent ship with Git, you\'ll want to
`curl https://raw.githubusercontent.com/MossTeK/nixosconfig/main/install.sh > install.sh && chmod +x ./install.sh`
