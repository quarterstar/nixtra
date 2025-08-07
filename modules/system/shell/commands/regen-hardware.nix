{ createCommand, ... }:

createCommand {
  name = "regen-hardware";
  buildInputs = [ ];

  command = ''
    nixos-generate-config --show-hardware-config > /etc/nixos/modules/system/hardware-configuration.nix
  '';
}
