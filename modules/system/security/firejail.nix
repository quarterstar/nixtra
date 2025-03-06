{ lib, profile, pkgs, ... }:

{
  programs.firejail.enable = profile.security.firejail;
}
