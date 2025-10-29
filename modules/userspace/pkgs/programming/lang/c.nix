{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    #clang
    gnumake
  ];
}
