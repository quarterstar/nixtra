{ profile, createCommand, ... }:

createCommand {
  name = "update";
  buildInputs = [];

  command = ''
    cd /etc/nixos && nix flake update
    ${profile.shell.commands.prefix}-rebuild
  '';
}
