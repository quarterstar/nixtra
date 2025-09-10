# https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/3

{ config, pkgs, ... }:

{
  qt = {
    enable = true;

    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=GraphiteNordDark
    '';

    "Kvantum/GraphiteNord".source =
      "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
  };
}
