{ profile, createCommand, ... }:

createCommand {
  name = "update";
  buildInputs = [ ];

  command = ''
    nix-channel --update
    nix flake update --flake /etc/nixos
    ${profile.shell.commands.prefix}-rebuild
  '';
}
