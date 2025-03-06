{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kiwix
  ];
}
