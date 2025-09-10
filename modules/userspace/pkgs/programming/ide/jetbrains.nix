{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains.idea-community-bin
    jetbrains.rust-rover
    jetbrains.clion
    jetbrains.pycharm-community-bin
  ];
}
