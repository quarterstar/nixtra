{ osConfig, nixtraLib, config, settings, ... }:

{
  imports = [
    #../../options.nix
    #../../system/desktop/flagship-hyprland/options.nix

    ./common.nix
    ../../../profiles/${settings.config.profile}/homes/user.nix

    # Desktops
    #(nixtraLib.loader.conditionalImport (config.nixtra.display.enable
    #  && config.nixtra.user.desktop.type == "flagship-hyprland")
    #  ../desktop/flagship-hyprland/prelude.nix)
    ../desktop/flagship-hyprland/user/prelude.nix
    ../desktop/flagship-hyprland/global/prelude.nix

    ../theme/type.nix
    ../theme/applications.nix

    # Out of order
    #../sources/flatpak.nix
  ];

  config = {
    #nixtra = osConfig.nixtra;

    xdg.configFile."mimeapps.list".force = true;

    home.sessionVariables = {
      BROWSER = config.nixtra.user.browser;
      DEFAULT_BROWSER = config.nixtra.user.browser;
    };

    home.username = config.nixtra.user.username;
    home.homeDirectory = "/home/${config.nixtra.user.username}";
    home.stateVersion = settings.system.version;
  };
}
