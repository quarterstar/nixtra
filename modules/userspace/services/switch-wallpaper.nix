{ profile, pkgs, lib, ... }:

{
  systemd.user.services."switch-wallpaper" = {
    enable = true;
    script = let
      wallpaperPaths = (lib.concatStringsSep " "
        (map (extension: "${profile.env.wallpaper.directory}/*.${extension}")
          profile.env.wallpaper.extensions));
    in "${pkgs.writeShellScript "switch-wallpaper.sh" ''
      #!/usr/bin/env bash

      WALLPAPER_DIR="${profile.env.wallpaper.directory}"

      if [ ! -d "$WALLPAPER_DIR" ]; then
        echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist."
        exit 1
      fi

      files=(${wallpaperPaths})

      if [ ''${#files[@]} -eq 0 ]; then
        echo "Error: No files found in $WALLPAPER_DIR"
        exit 1
      fi

      while true; do
        random_wallpaper="''${files[RANDOM % ''${#files[@]}]}"

        pkill -x swww || true

        echo "Setting wallpaper: $random_wallpaper"
        swww img "$random_wallpaper"

        echo "Wallpaper set successfully!"

        sleep ${builtins.toString profile.env.wallpaper.switchInterval}
      done
    ''}";
    wantedBy = [ "default.target" ];
    path = with pkgs; [ uutils-coreutils-noprefix swww procps ];
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/home"; # Required to access home directory files
      ProtectHome = false;
      Restart = "always";
      RestartSec = 0;
    };
  };
}
