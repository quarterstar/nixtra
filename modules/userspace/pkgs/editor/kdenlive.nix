{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdenlive

    # Required for KDE apps
    libsForQt5.full
    libsForQt5.kirigami-addons
  ];
}
