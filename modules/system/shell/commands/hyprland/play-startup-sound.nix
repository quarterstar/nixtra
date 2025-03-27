{ pkgs, profile, createCommand, ... }:

if profile.display.type == "hyprland" then createCommand {
  name = "hyprland-play-startup-sound";
  buildInputs = with pkgs; [ grim slurp ];

  command = ''
    #!/usr/bin/env bash

    # Wait until Hyprland is fully initialized
    while ! ${pkgs.hyprland}/bin/hyprctl monitors > /dev/null 2>&1; do
      sleep 1
    done

    ${pkgs.vlc}/bin/vlc --vout none --intf dummy /etc/nixos/assets/audio/boot.mp3
  '';
} else {}
