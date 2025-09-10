{ config, pkgs, ... }:

{
  programs.cava.enable = true;
  #home.packages = with pkgs; [ cava ];
}
