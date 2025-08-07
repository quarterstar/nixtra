# Nixtra - Installation

> [!WARNING]
> Nixtra uses a lot of disk space as a consequence of coming with many applications and services pre-configured and pre-installed. Choose a disk for installation with caution.

Thank you for choosing to try Nixtra! This section focuses on the installation of it os that the other ones go more in depth about operation and customization. The following are the instructions for installation:

1. Download the latest [NixOS minimal installation ISO](https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-x86_64-linux.iso)
1. Burn it to your preferred USB drive with `sudo dd if=<iso> of=/dev/<device> status=progress`
1. Reboot your PC to the NixOS installation media
1. Download and run the Nixtra installation script: `curl https://raw.githubusercontent.com/quarterstar/nixtra/refs/heads/main/net/install.sh | sh`
1. Reboot your PC and enjoy your new system!
