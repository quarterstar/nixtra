{ config, createCommand, ... }:

createCommand {
  name = "upgrade";
  buildInputs = [ ];

  command = ''
    nix-channel --update
    nix flake update --flake /etc/nixos
    ${config.nixtra.shell.commands.prefix}-rebuild --upgrade
  '';
}
