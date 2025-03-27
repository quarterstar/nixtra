{ ... }:

{
  imports = [
    ./update.nix
    ./doas.nix
    ./firewall.nix
    ./audit.nix
    ./firejail.nix
    ./close-on-suspend.nix
    ./uutils.nix
  ];
}
