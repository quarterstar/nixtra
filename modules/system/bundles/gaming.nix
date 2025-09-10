{ config, pkgs, ... }:

{
  imports = [ ../pkgs/emu/waydroid.nix ../services/steam.nix ];
}
