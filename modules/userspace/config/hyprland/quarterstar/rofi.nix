{ pkgs, ... }:

{
  home.file = {
    ".config/rofi/config.rasi" = {
      source = ../../../../../config/profile/hyprland/quarterstar/rofi/config.rasi;
      executable = false;
      force = true;
    };

    ".local/share/themes/rofi/nixtra.rasi" = {
      source = ../../../../../config/profile/hyprland/quarterstar/rofi/nixtra.rasi;
      executable = false;
      force = true;
    };
  };
}
