{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Required to run AppImage files
    appimage-run

    # Plugins
    universal-ctags
  ];
}
