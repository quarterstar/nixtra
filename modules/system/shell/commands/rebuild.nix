{ pkgs, profile, createCommand, ... }:

createCommand {
  inherit pkgs;
  inherit profile;
  name = "rebuild";
  buildInputs = with pkgs; [ grim slurp ];

  command = ''
    nixos-rebuild switch --flake /etc/nixos#default
  '';
}
