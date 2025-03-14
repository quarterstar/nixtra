{ pkgs, profile, createCommand, ... }:

createCommand {
  inherit pkgs;
  inherit profile;
  name = "rebuild";
  buildInputs = with pkgs; [ grim slurp ];

  command = ''
    cd /etc/nixos
    git add --intent-to-add .
    cd - > /dev/null
    nixos-rebuild switch --flake /etc/nixos#default
  '';
}
