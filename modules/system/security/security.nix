{ config, ... }:

{
  imports = [
    ./boot.nix
    ./kernel.nix
    ./systemd.nix
    ./permissions.nix
    #./impermanence.nix
    ./usb.nix
    #./services.nix
    #./suricata.nix
    #./dns.nix
    ./fail2ban.nix
    ./virtualisation.nix
    ./update.nix
    ./gc.nix
    ./doas.nix
    ./firewall.nix
    ./audit.nix
    ./firejail.nix
    ./close-on-suspend.nix
    ./uutils.nix
    ./sops.nix
    ./vpn.nix
  ];
}
