{ pkgs, ... }:

{
  home.packages = with pkgs;
    [
      krita # General drawing tool
    ];
}
