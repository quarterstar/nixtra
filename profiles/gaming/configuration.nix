{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system/shell/aliases.nix
    ../../modules/system/emu/waydroid.nix
    ../../modules/system/pkgs/emu/waydroid.nix
  ];
}
