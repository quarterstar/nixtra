{ profile, ... }:

if profile.security.firewall.enable then {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = profile.security.firewall.allowedTCPPorts;
    allowedUDPPorts = profile.security.firewall.allowedTCPPorts;
  };
} else {}
