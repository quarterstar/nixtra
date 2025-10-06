{ config, pkgs, ... }:

{
  imports = [
    ../pkgs/emu/waydroid.nix
    ../pkgs/performance/gamemode.nix
    ../services/steam.nix
  ];
}
