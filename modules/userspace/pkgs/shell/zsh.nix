# Modified version of: https://tesar.tech/blog/2024-10-21_nix_os_zsh_autocomplete

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    oh-my-posh
    git
  ];

  programs.zsh = {
    enable = true;
  };
}
