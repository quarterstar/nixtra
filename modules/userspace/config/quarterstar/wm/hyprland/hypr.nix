{ profile, pkgs, ... }:

{
  home.file = {
    ".config/hypr/hyprland.conf" = {
      source = ../../../../../../config/${profile.user.config}/wm/hyprland/hypr/hyprland.conf;
      executable = false;
      force = true;
    };
  };
}
