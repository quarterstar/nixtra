{ profile, stdenv, pkgs, ... }:

if profile.shell.commands.enable then
{
  environment.systemPackages = [
    (pkgs.callPackage ./screenshot.nix { })
    (pkgs.callPackage ./rebuild.nix { })
    (pkgs.callPackage ./record.nix { })
    (pkgs.callPackage ./update.nix { inherit profile; })
    (pkgs.callPackage ./regen-hardware.nix { })
    (pkgs.callPackage ./regen-bootloader.nix { })
    (pkgs.callPackage ./fix-bootloader.nix { inherit profile; })
    (pkgs.callPackage ./create-iso.nix { })
    (pkgs.callPackage ./clean.nix { })
    (pkgs.callPackage ./check-cliphist-store.nix { inherit profile; })
    (pkgs.callPackage ./hyprland/play-startup-sound.nix { inherit profile; })
  ];
} else {}
