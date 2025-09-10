{ config, pkgs, ... }:

{
  home.packages = with pkgs;
    [
      openboard # Whiteboard
    ];
}
