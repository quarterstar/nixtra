{ pkgs, ... }:

{
  home.file = {
    ".config/hypr/hyprland.conf" = {
      source = ../../../../../config/profile/hyprland/quarterstar/hypr/hyprland.conf;
      executable = false;
      force = true;
    };
  };
}
