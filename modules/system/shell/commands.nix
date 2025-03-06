{ profile, stdenv, pkgs, ... }:

if profile.shell.commands.enable then
{
  environment.systemPackages = [
    (pkgs.callPackage ./commands/screenshot.nix { inherit profile; })
    (pkgs.callPackage ./commands/rebuild.nix { inherit profile; })
    (pkgs.callPackage ./commands/record.nix { inherit profile; })
  ];
} else {}
