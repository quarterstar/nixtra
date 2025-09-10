{ config, createCommand, ... }:

createCommand {
  name = "update";
  buildInputs = [ ];

  command = ''
    nix-channel --update
    nix flake update --flake /etc/nixos
    ${config.nixtra.shell.commands.prefix}-rebuild
  '';
}
