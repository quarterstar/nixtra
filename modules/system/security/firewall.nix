{ lib, config, ... }:

{
  config = lib.mkIf config.nixtra.security.firewall.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = config.nixtra.security.firewall.allowedTCPPorts;
      allowedUDPPorts = config.nixtra.security.firewall.allowedTCPPorts;
    };
  };
}
