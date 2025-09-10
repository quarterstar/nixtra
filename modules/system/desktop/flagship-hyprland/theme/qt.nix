# https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/2

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
  ];

  #nixpkgs.config.qt5 = {
  #  enable = true;
  #  platformTheme.name = "qt5ct"; 
  #  style = {
  #    package = pkgs.utterly-nord-plasma;
  #    name = "Utterly Nord Plasma";
  #  };
  #};

  environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";
}
