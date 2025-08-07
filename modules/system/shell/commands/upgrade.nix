{ profile, createCommand, ... }:

createCommand {
  name = "upgrade";
  buildInputs = [ ];

  command = ''
    nix-channel --update
    nix flake update --flake /etc/nixos
    ${profile.shell.commands.prefix}-rebuild --upgrade
  '';
}
