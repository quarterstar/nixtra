{ pkgs, ... }:

{
  home.packages = with pkgs; [
    inkscape # SVG tool
  ];
}
