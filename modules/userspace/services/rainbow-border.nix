{ pkgs, ... }:

{
  systemd.user.services."rainbow-border" = {
    enable = true;
    script = "${pkgs.writeShellScript "rainbow-border.sh" (builtins.readFile ../../../scripts/rainbow-border.sh)}";
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      hyprland
      coreutils
    ];
  };
}
