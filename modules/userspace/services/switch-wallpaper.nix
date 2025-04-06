{ profile, pkgs, ... }:

{
  systemd.user.services."switch-wallpaper" = {
    enable = true;
    script = "${pkgs.writeShellScript "switch-wallpaper.sh" ''
      #!/usr/bin/env bash

      # Configuration
      WALLPAPER_DIR="$HOME/Pictures/wallpapers"  # Change this to your wallpaper directory

      # Check if the wallpaper directory exists
      if [ ! -d "$WALLPAPER_DIR" ]; then
        echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist."
        exit 1
      fi

      # Find all .gif files in the directory
      gif_files=("$WALLPAPER_DIR"/*.gif)

      # Check if any .gif files were found
      if [ ''${#gif_files[@]} -eq 0 ]; then
        echo "Error: No .gif files found in $WALLPAPER_DIR"
        exit 1
      fi

      # Select a random .gif file
      random_gif="''${gif_files[RANDOM % ''${#gif_files[@]}]}"

      # Kill any existing swayimg processes to avoid multiple instances
      pkill -x swayimg

      # Set the new wallpaper
      echo "Setting wallpaper: $random_gif"
      swww img "$random_gif"

      echo "Wallpaper set successfully!"
    ''}";
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      uutils-coreutils-noprefix
      swww
      procps
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
