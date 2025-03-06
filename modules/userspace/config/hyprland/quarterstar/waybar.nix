{ pkgs, ... }:

{
  home.file = {
    ".config/waybar/config" = {
      source = ../../../../../config/profile/hyprland/quarterstar/waybar/config;
      executable = false;
      force = true;
    };

    ".config/waybar/style.css" = {
      source = ../../../../../config/profile/hyprland/quarterstar/waybar/style.css;
      executable = false;
      force = true;
    };
  };
}
