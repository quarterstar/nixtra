{ config, profile, pkgs, ... }:

let
  # Function to generate Waybar custom modules
  mkAppModule = app: {
    name = "custom/${app.program}";
    value = {
      #format = "<img src='~/.config/waybar/icons/${app.icon}' width='24' height='24'/>";
      format = "    ";
      on-click = "${app.program}";
      # Optional: Add tooltip
      tooltip = false;
      # Optional: Add CSS class for styling
      class = "app-icon";
    };
  };

  # Generate all custom modules
  customModules = builtins.listToAttrs (map mkAppModule profile.env.wm.apps);

  # Generate the modules-center array
  appModules = map (app: "custom/${app.program}") profile.env.wm.apps;
in {
  home.file = {
    ".config/waybar/config-top" = {
      source = ../../../../../config/profile/hyprland/quarterstar/waybar/config-top;
      executable = false;
      force = true;
    };

    ".config/waybar/style-top.css" = {
      source = ../../../../../config/profile/hyprland/quarterstar/waybar/style-top.css;
      executable = false;
      force = true;
    };

    ".config/waybar/style-bottom.css" = {
      source = ../../../../../config/profile/hyprland/quarterstar/waybar/style-bottom.css;
      executable = false;
      force = true;
    };

    ".config/waybar/icons" = {
      source = ../../../../../assets/icons;
      executable = false;
      force = true;
    };
  };

  programs.waybar.settings = {
    "config-bottom" = {
      reload_style_on_change = true;
      layer = "bottom";
      position = "bottom";
      disable-scroll = true;
      height = 30;
      modules-center = appModules;
      
      custom = customModules;
    };
  };

  xdg.configFile."waybar/config-bottom".text = builtins.toJSON config.programs.waybar.settings."config-bottom";
}
