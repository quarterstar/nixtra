# https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/3

{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (config.nixtra.user.desktop == "flagship-hyprland") {
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

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
    };
  };
}
