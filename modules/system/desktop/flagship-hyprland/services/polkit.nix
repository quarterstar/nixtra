{ config, lib, ... }:

{
  config = lib.mkIf (config.nixtra.user.desktop == "flagship-hyprland") {
    security.polkit.enable = true;
  };
}
