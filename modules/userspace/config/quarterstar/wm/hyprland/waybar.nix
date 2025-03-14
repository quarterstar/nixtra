{ config, profile, ... }:

let
  # Function to generate Waybar custom modules
  mkAppModule = app: {
    name = "custom/${app.program}";
    value = {
      format = "    ";
      on-click = "/home/user/.nix-profile/bin/${app.program}";
      tooltip = false;
      class = "app-icon";
    };
  };

  iconSize = builtins.toString profile.env.wm.taskbar.iconSize;

  mkCssRule = app: ''
    #custom-${app.program} {
      background-image: url('/home/${profile.user.username}/.config/waybar/icons/${app.icon}');
      background-position: center;
      background-repeat: no-repeat;
      background-size: ${iconSize}px ${iconSize}px;
      min-width: ${iconSize}px;
      min-height: ${iconSize}px;
    }
  '';

  # Nixtra's logo
  nixtraCssRule = ''
    #custom-nixtra {
      background-image: url('/home/${profile.user.username}/.config/waybar/icons/nixtra.png');
      background-position: center;
      background-repeat: no-repeat;
      /*background-size: 128px 42px;*/
      /*min-width: 128px;*/
      /*min-height: 42px;*/
      background-size: 96px 32px;
      min-width: 96px;
      min-height: 32px;
      margin-left: 15px;
    }
  '';

  # Generate all custom modules
  customModules = builtins.listToAttrs (map mkAppModule profile.env.wm.taskbar.apps);
  customCssRules = builtins.concatStringsSep "\n" (map mkCssRule profile.env.wm.taskbar.apps);
  cssRules = customCssRules + "\n" + nixtraCssRule;

  # Generate the modules-center array
  appModules = map (app: "custom/${app.program}") profile.env.wm.taskbar.apps;
in {
  home.file = {
    ".config/waybar/config-top" = {
      source = ../../../../../../config/${profile.user.config}/wm/hyprland/waybar/config-top;
      executable = false;
      force = true;
    };

    ".config/waybar/style-top.css" = {
      source = ../../../../../../config/${profile.user.config}/wm/hyprland/waybar/style-top.css;
      executable = false;
      force = true;
    };

    ".config/waybar/icons" = {
      source = ../../../../../../assets/icons;
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
      modules-center = appModules;
      modules-left = [ "custom/nixtra" ];

      "custom/nixtra" = {
        format = "    ";
        on-click = "/home/user/.nix-profile/bin/${profile.user.browser} https://github.com/quarterstar/nixtra";
        tooltip = false;
      };
    } // customModules;
  };

  xdg.configFile."waybar/config-bottom".text = builtins.toJSON config.programs.waybar.settings."config-bottom";
  xdg.configFile."waybar/style-bottom.css".text = builtins.readFile ../../../../../../config/${profile.user.config}/wm/hyprland/waybar/style-bottom.css + "\n" + cssRules;
}
