{ pkgs, ... }:

{
  systemd.services.enableNicOffload = {
    description = "Enable NIC offload features via ethtool";
    # ensure it runs before networking is fully online
    wantedBy = [ "network-pre.target" ];
    after = [ "network-pre.target" ];

    path = with pkgs; [ ethtool ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        iface=$(ip route get 1.1.1.1 | awk '{print $3}')
        ${pkgs.ethtool}/bin/ethtool -K $iface gro on
        ${pkgs.ethtool}/bin/ethtool -K $iface tso on
        ${pkgs.ethtool}/bin/ethtool -K $iface gso on
      '';
    };
  };
}
