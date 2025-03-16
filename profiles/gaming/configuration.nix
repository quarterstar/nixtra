{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system/emu/waydroid.nix
    ../../modules/system/pkgs/emu/waydroid.nix
  ];
}
