# Everything defined here is added to `config.nixtra`.
# See configuration documentation for more information.

{ config, pkgs, ... }:

{
  desktop = {
    startupPrograms =
      [ "keepassxc" config.nixtra.user.terminal config.nixtra.user.browser ];
  };

  security = {
    vpn = {
      enable = true;
      type = "mullvad";
    };
  };

  scheduledTasks = [{
    enable = true;
    name = "system-shutdown";
    time = "23:00";
    action = "shutdown now";
  }];
}
