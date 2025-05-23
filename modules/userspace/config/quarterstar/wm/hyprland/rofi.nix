{ profile, config, pkgs, ... }:

{
  home.file = {
    ".config/rofi/config.rasi" = {
      source = ../../../../../../config/${profile.user.config}/wm/hyprland/rofi/config.rasi;
      executable = false;
      force = true;
    };

    ".local/share/rofi/themes/nixtra.rasi" = {
      source = ../../../../../../config/${profile.user.config}/wm/hyprland/rofi/nixtra.rasi;
      executable = false;
      force = true;
    };
  };
}
