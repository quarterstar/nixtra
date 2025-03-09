{ pkgs, profile, createCommand, ... }:

createCommand {
  inherit pkgs;
  inherit profile;
  name = "create-iso";
  buildInputs = [];

  command = ''
    nix build /etc/nixos#nixosConfigurations.default.config.system.build.isoImage 
  '';
}
