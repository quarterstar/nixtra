{ profile, stdenv, pkgs, ... }:

if profile.shell.commands.enable then
{
  environment.systemPackages = [
    (pkgs.callPackage ./commands/screenshot.nix { inherit profile; })
    (pkgs.callPackage ./commands/rebuild.nix { inherit profile; })
    (pkgs.callPackage ./commands/record.nix { inherit profile; })
    (pkgs.callPackage ./commands/update.nix { inherit profile; })
    (pkgs.callPackage ./commands/regen-hardware.nix { inherit profile; })
    (pkgs.callPackage ./commands/regen-bootloader.nix { inherit profile; })
    (pkgs.callPackage ./commands/fix-bootloader.nix { inherit profile; })
    (pkgs.callPackage ./commands/create-iso.nix { inherit profile; })
    (pkgs.callPackage ./commands/clean.nix { inherit profile; })
    (pkgs.callPackage ./commands/hyprland/play-startup-sound.nix { inherit profile; })
  ];
} else {}
