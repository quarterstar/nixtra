{ profile, lib, pkgs, ... }:

if profile.flatpak.enable then {
  services.flatpak.enable = true;

  system.activationScripts.installFlathub = (lib.concatStringsSep "\n" (map
    (source:
      "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists ${source.name} ${source.source}")
    profile.flatpak.sources));

  security.wrappers."bwrap" = {
    owner = "root";
    group = "root";
    source = "${pkgs.bubblewrap}/bin/bwrap";
    setuid = true;
  };
} else
  { }
