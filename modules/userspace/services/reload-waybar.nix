{ pkgs, ... }:

{
  # https://github.com/Alexays/Waybar/issues/961#issuecomment-753533975
  systemd.user.services."reload-waybar" = {
    enable = true;
    script = "${pkgs.writeShellScript "reload-waybar.sh" (builtins.readFile ../../../scripts/reload-waybar.sh)}";
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      waybar
      killall
      inotify-tools
      procps
    ];
    serviceConfig = {
      Type = "simple"; # Use "simple" for long-running services
      Restart = "always";
      RestartSec = 0;
    };
  };
}
