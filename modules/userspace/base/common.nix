{ pkgs, profile, ... }:

{
  imports = [
    (../pkgs/terminal + ("/" + profile.user.terminal) + ".nix")
    (../pkgs/shell + ("/" + profile.user.shell) + ".nix")

    ../theme/type.nix
    ../theme/applications.nix

    ../config/global/prelude.nix
    (../config + ("/" + profile.user.config) + "/prelude.nix")
  ];

  home.sessionVariables = {
    EDITOR = profile.user.editor;
    BROWSER = profile.user.browser;
    DEFAULT_BROWSER = profile.user.browser;
    TERMINAL = profile.user.terminal;
  };

  # Enable automatic management of directories specified in the XDG specification
  # https://xdgbasedirectoryspecification.com/
  xdg = {
    enable = true;
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };

  # Fix Portal v1.17+ incompatibility
  xdg.portal.config.common.default = "*";

  # Fix https://github.com/nix-community/home-manager/issues/1213
  xdg.configFile."mimeapps.list".force = true;
}
