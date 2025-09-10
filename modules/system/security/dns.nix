{ config, pkgs, lib, ... }:

{
  # Prevent NetworkingManager from fetching DNS settings
  # via DHCP (i.e., getting the router's preferred DNS
  # configurations).
  #
  # Even if the user is not using a VPN, the preconfigured
  # DNS servers are better in terms of privacy than the
  # ISP-issues ones most of the time.
  system.activationScripts."disable-fetch-router-dns".text = ''
    export PATH=${pkgs.networkmanager}/bin:${pkgs.systemd}/bin:$PATH
    set -euo pipefail

    if [[ "$(systemctl is-system-running)" != "running" ]]; then
      exit 0
    fi

    echo "Updating NetworkManager connections..."

    mapfile -t connections < <(nmcli -t -f NAME connection show)

    exceptions=(${
      lib.concatStringsSep " "
      config.nixtra.security.nmConnectionRouterDnsExceptions
    })

    for conn in "''${connections[@]}"; do
      if [[ " ''${connections[@]} " =~ " ''${conn} " ]]; then
        continue
      fi

      ipv4_setting=$(nmcli -g ipv4.ignore-auto-dns connection show "$conn")
      ipv6_setting=$(nmcli -g ipv6.ignore-auto-dns connection show "$conn")

      if [[ "$ipv4_setting" == "yes" && "$ipv6_setting" == "yes" ]]; then
        continue
      fi

      nmcli connection modify "$conn" ipv4.ignore-auto-dns yes
      nmcli connection modify "$conn" ipv6.ignore-auto-dns yes

      nmcli connection down "$conn" || true  # Don't fail if already disconnected
      nmcli connection up "$conn"
    done

    echo "All connections have been updated"
  '';

  # TODO
  #systemd.user.services."dns-leak-test" = {
  #  enable = true;
  #  after = [ "graphical.target" ];
  #  script = ''
  #    ${pkgs.libnotify}/bin/notify-send -u critical "DNS Leak Detected" "Nixtra has detected a potential DNS Leak with your VPN configuration."
  #  '';
  #  serviceConfig = { Type = "oneshot"; };
  #};

  # Define the option for exceptions if not already defined elsewhere
  # (e.g., in a separate module or top-level configuration)
  options.config.nixtra.security.nmConnectionRouterDnsExceptions =
    lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of NetworkManager connection names for which router-provided
        DNS settings should NOT be ignored.
      '';
    };
}
