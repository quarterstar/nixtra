{ config, lib, pkgs, ... }:

{
  programs.firejail.enable = config.nixtra.security.firejail;
}
