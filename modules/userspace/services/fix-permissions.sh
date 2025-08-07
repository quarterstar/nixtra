{ profile, pkgs, lib, ... }:

{
  systemd.services.fix-permissions = {
    enable = true;
    script = "${pkgs.writeShellScript "switch-wallpaper.sh" ''
      #!/usr/bin/env bash
    
      find /home/user -type d -print0 | xargs -0 chmod 0775
      find /home/user -type f -print0 | xargs -0 chmod 0664
      chown -R user:users /home/${profile.user.username}

      sleep 300 # 5 minutes
    ''}";
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      uutils-coreutils-noprefix
      swww
      procps
    ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 0;
    };
  };
}
