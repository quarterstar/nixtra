{ config, ... }:

{
  imports = [
    ./gnupg.nix
    ./kitty.nix
    ./swayimg.nix
    ./gromit.nix
    ./lunarvim.nix
    ./neovim.nix
    ./freetube.nix
  ];
}
