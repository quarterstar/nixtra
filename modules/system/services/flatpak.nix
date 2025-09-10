{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.nixtra.flatpak.enable {
    services.flatpak.enable = true;

    system.activationScripts.installFlathub = (lib.concatStringsSep "\n" (map
      (source:
        "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists ${source.name} ${source.source}")
      config.nixtra.flatpak.sources));

    security.wrappers."bwrap" = {
      owner = "root";
      group = "root";
      source = "${pkgs.bubblewrap}/bin/bwrap";
      setuid = true;
    };
  };
}
