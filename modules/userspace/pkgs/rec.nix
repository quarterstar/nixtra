{ pkgs, ... }:

{
  home.packages = with pkgs; [ obs-studio flameshot grim ];
}
