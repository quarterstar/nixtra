{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #rkhunter
    lynis
    clamav
  ];

  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
}
