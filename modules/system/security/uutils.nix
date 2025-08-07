{ profile, pkgs, ... }:

if profile.security.replaceCoreutilsWithUutils then {
  environment.systemPackages = with pkgs; [ uutils-coreutils-noprefix ];
} else
  { }
