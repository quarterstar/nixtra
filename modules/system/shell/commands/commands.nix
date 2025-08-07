{ profile, stdenv, pkgs, ... }:

if profile.shell.commands.enable then {
  environment.systemPackages = [
    (pkgs.callPackage ./screenshot.nix { })
    (pkgs.callPackage ./rebuild.nix { inherit profile; })
    (pkgs.callPackage ./check.nix { inherit profile; })
    (pkgs.callPackage ./record.nix { })
    (pkgs.callPackage ./unlock.nix { inherit profile; })
    (pkgs.callPackage ./update.nix { inherit profile; })
    (pkgs.callPackage ./upgrade.nix { inherit profile; })
    (pkgs.callPackage ./regen-hardware.nix { })
    (pkgs.callPackage ./regen-bootloader.nix { })
    (pkgs.callPackage ./fix-bootloader.nix { inherit profile; })
    (pkgs.callPackage ./enter-temp-fhs.nix { })
    (pkgs.callPackage ./create-iso.nix { })
    (pkgs.callPackage ./hide-git-dir.nix { })
    (pkgs.callPackage ./unhide-git-dir.nix { })
    (pkgs.callPackage ./clean.nix { inherit profile; })
    (pkgs.callPackage ./check-cliphist-store.nix { inherit profile; })
    (pkgs.callPackage ./hyprland/play-startup-sound.nix { inherit profile; })
    (pkgs.callPackage ./theme/reset-cursor.nix { })
  ];
} else
  { }
