{ config, lib, pkgs, ... }:

let
  cfg = config.nixtra.security.vpn;
  mullvad-autostart = pkgs.makeAutostartItem {
    name = "mullvad-vpn";
    package = pkgs.mullvad-vpn;
  };
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      networking.firewall.checkReversePath = "loose";
      networking.iproute2.enable = true;
    })
    (lib.mkIf (cfg.enable && cfg.type == "mullvad") {

      environment.systemPackages = with pkgs; [ mullvad-autostart cowsay ];

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
    })
    (lib.mkIf (cfg.enable && cfg.type == "wireguard") {
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
    })
  ];
}
