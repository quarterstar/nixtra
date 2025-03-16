{ profile, pkgs, ... }:

let
  switchInterval = profile.env.wallpaper.switchInterval * 60;
  random-wallpaper = pkgs.callPackage ../../drvs/wayland-random-wallpaper/default.nix {};
in {
  systemd.user.services."switch-wallpaper" = {
    enable = true;
    script = "${pkgs.writeShellScript "switch-wallpaper.sh" ''
      #!/usr/bin/env bash

      while true; do
        random-wallpaper
        ${pkgs.uutils-coreutils-noprefix}/bin/sleep ${builtins.toString switchInterval}
      done
    ''}";
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      random-wallpaper
      uutils-coreutils-noprefix
    ];
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/home"; # Required to access home directory files
      ProtectHome = false;
      Restart = "always";
      RestartSec = 0;
    };
  };
}
