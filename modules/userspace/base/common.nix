{ osConfig, settings, nixtraLib, lib, config, pkgs, ... }:

{
  imports = [
    #../../options.nix
    #../../system/desktop/flagship-hyprland/options.nix

    # Terminals
    (nixtraLib.loader.conditionalImport (config.nixtra.user.terminal == "kitty")
      ../pkgs/terminal/kitty.nix)

    # Shells
    (nixtraLib.loader.conditionalImport (config.nixtra.user.shell == "bash")
      ../pkgs/shell/bash.nix)
    (nixtraLib.loader.conditionalImport (config.nixtra.user.shell == "starship")
      ../pkgs/shell/starship.nix)
    (nixtraLib.loader.conditionalImport (config.nixtra.user.shell == "zsh")
      ../pkgs/shell/zsh.nix)
    (nixtraLib.loader.conditionalImport (config.nixtra.user.shell == "fish")
      ../pkgs/shell/fish.nix)

    ../config/prelude.nix
  ];

  config = {
    home.sessionVariables = {
      EDITOR = config.nixtra.user.editor;
      TERMINAL = config.nixtra.user.terminal;
    };

    # Enable automatic management of directories specified in the XDG specification
    # https://xdgbasedirectoryspecification.com/
    xdg = { enable = true; };

    # Fix https://github.com/nix-community/home-manager/issues/1213
    #xdg.configFile."mimeapps.list".force = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs;
        [
          kdePackages.xdg-desktop-portal-kde
          #xdg-desktop-portal-gtk
        ];

      config = {
        # Fix Portal v1.17+ incompatibility
        common.default = "*";

        #"org.freedesktop.impl.portal.FileChooser" = { default = "kde"; };
      };
    };
  };
}
