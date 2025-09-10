{ config, pkgs, lib, inputs, ... }:

{
  config = lib.mkIf config.nixtra.security.autoUpdate {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "-L" # Print build logs
      ];
      dates = "daily";
      randomizedDelaySec = "45min"; # Jitter
      operation = "switch";
    };

    environment.systemPackages = with pkgs;
      lib.mkIf config.nixtra.user.desktop.enable [ libnotify systembus-notify ];

    services.systembus-notify.enable = config.nixtra.user.desktop.enable;

    systemd.services."nixos-upgrade" =
      lib.mkIf config.nixtra.user.desktop.enable {
        unitConfig = {
          OnSuccess = "${pkgs.systemd}/bin/machinectl --uid=${
              builtins.toString config.nixtra.user.uid
            } shell ${pkgs.systemd}/bin/systemctl --machine=${config.nixtra.user.username}@.host --user start nixos-upgrade-notification.service";
          OnFailure = "${pkgs.systemd}/bin/machinectl --uid=${
              builtins.toString config.nixtra.user.uid
            } shell ${pkgs.systemd}/bin/systemctl --machine=${config.nixtra.user.username}@.host --user start nixos-upgrade-notification@failure.service";
        };
      };

    systemd.user.services = {
      nixos-upgrade-notification = {
        serviceConfig = {
          ExecStart =
            "${pkgs.libnotify}/bin/notify-send 'System Update Completed' 'An automatic system update has been completed successfully.'";
          Type = "oneshot";
        };
      };
    };
  };
}
