{ config, pkgs, ... }:

{
  home.packages = with pkgs;
    [
      drawio # Infrastructure diagrams
    ];
}
