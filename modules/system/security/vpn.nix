{ config, lib, pkgs, ... }:

let
  cfg = config.nixtra.security.vpn;
  mullvad-autostart = pkgs.makeAutostartItem {
    name = "mullvad-vpn";
    package = pkgs.mullvad-vpn;
  };
in {
  config = lib.mkIf cfg.enable ({
    networking.firewall.checkReversePath = "loose";
    networking.iproute2.enable = true;
  } // lib.mkIf (cfg.type == "mullvad") {
    environment.systemPackages = [ mullvad-autostart ];

    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn;

    # https://discourse.nixos.org/t/connected-to-mullvadvpn-but-no-internet-connection/35803/12
    #networking.networkmanager = {
    #  dns = "default";
    #  settings = { "main" = { rc-manager = "resolvconf"; }; };
    #};

    services.resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      domains = [ "~." ];
      fallbackDns = [ ]; # Prevent DNS leaks
      dnsovertls = "true";
    };
  } // lib.mkIf (cfg.type == "wireguard") {
    environment.systemPackages = with pkgs; [ wireguard-tools ];

    networking.wireguard = {
      enable = true;
      interfaces = {
        wg0 = with config.sops; {
          ips = config.nixtra.security.vpn.addresses;
          privateKeyFile =
            config.sops.secrets."${config.nixtra.security.vpn.privateKey}".path;
          listenPort = 51820;

          peers = [{
            publicKey = config.nixtra.security.vpn.publicKey;
            endpoint =
              "${config.nixtra.security.vpn.endpointAddress}:${config.nixtra.security.vpn.endpointPort}";
            allowedIPs = [ "0.0.0.0/0" "::0/0" ];
            persistentKeepalive = 25;
          }];
        };
      };
    };

    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

    #networking.nat = {
    #  enable = true;
    #  externalInterface = "enp24s0";
    #  internalInterfaces = [ "wg0" ];
    #};
  });
}
