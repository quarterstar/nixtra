{ pkgs, profile, createCommand, ... }:

createCommand {
  inherit pkgs;
  inherit profile;
  name = "update";
  buildInputs = [];

  command = ''
    cd /etc/nixos && nix flake update
    ${profile.shell.commands.prefix}-rebuild
  '';
}
