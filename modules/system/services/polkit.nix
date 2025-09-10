{ config, pkgs, ... }:

{
  # Fix authorization error
  security.polkit.enable = true;
}
