{ profile, lib, pkgs, ... }:

{
  # https://github.com/Alexays/Waybar/issues/961#issuecomment-753533975
  systemd.user.services."reload-waybar" = {
    enable = true;
    script = "${pkgs.writeShellScript "reload-waybar.sh" ''
      #!/usr/bin/env bash

      waybar -c "$HOME/.config/waybar/config-top" -s "$HOME/.config/waybar/config-top.css" &
      waybar -c "$HOME/.config/waybar/config-bottom" -s "$HOME/.config/waybar/config-bottom.css"
    ''}";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    path = with pkgs; [ waybar inotify-tools procps uutils-coreutils-noprefix ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 0;
    };
  };
}
