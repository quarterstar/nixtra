{ profile, pkgs, ... }:

if profile.tor.enable then
{
  # Define the microsocks service
  systemd.services.microsocks = {
    description = "MicroSocks SOCKS5 Proxy";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.proxychains}/bin/proxychains4 ${pkgs.microsocks}/bin/microsocks -p 1080";
      Restart = "on-failure";
      RestartSec = "5s";
      User = "nobody"; # Run as an unprivileged user
    };
  };

  # Stub service
  # This is done so that the tor user is created and managed by NixOS
  services.tor = {
    enable = true;
    settings.SOCKSPort = 9000;
  };

  systemd.services.tor1 = {
    description = "Tor Service (No Proxy)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.tor}/bin/tor -f ${pkgs.writeText "torrc1" ''
        SocksPort 9050
        DataDirectory /home/tor/tor1
      ''}";
      Type = "simple";
      User = "tor";
      Group = "tor";
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  systemd.services.tor2 = {
    description = "Tor Service (Proxy)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.tor}/bin/tor -f ${pkgs.writeText "torrc2" ''
        SocksPort 9150
        DataDirectory /home/tor/tor2
      ''}";
      Type = "simple";
      User = "tor";
      Group = "tor";
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  # Ensure the data directories exist and have the correct permissions
  system.activationScripts.torSetup = ''
    mkdir -p /home/tor
    chown -R tor:tor /home/tor
  '';
} else {}
