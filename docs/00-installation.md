# Nixtra - Installation

Thank you for choosing to try Nixtra! This section focuses on the installation of it os that the other ones go more in depth about operation and customization. The following are the instructions for installation:

## Via Nixtra ISO



## Via Manual Installation

If you are not the root user already, switch with sudo:

```
sudo su
```

First, clone the Nixtra repository using Git:

```
git clone https://github.com/quarterstar/nixtra
```

If your environment is missing `git`, you can temporarily install it using the `nix-shell` command:

```
nix-shell -p git
```

Then, generate a NixOS hardware configuration so that the system is configured according to your exact hardware being used:

```
sudo nixos-generate-config --show-hardware-config > /etc/nixos/modules/system/hardware-configuration.nix
```

Afterwards, make sure to change the `gpu` setting in Nixtra's `settings.nix` file provided in `/etc/nixos/settings.nix` to reflect your GPU manufacturer. Use any of the following options:

- `amd`
- `nvidia`
- `none` (if GPU is not supported by the above options)

Finally, use the `nixos-rebuild` command to build the initial state of your system:

```
nixos-rebuild switch --flake /etc/nixos#default
```

If you encounter any weird errors, make sure to build using the `--show-trace` argument for better troubleshooting of the error:

```
nixos-rebuild switch --flake /etc/nixos#default --show-trace
```



