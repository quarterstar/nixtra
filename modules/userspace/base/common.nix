{ runCommand, runtimeShell, lib, profile, pkgs, ... }:

{
  imports = [
    (../pkgs/terminal + ("/" + profile.user.terminal) + ".nix") 
    (../pkgs/shell + ("/" + profile.user.shell) + ".nix")

    ../theme/type.nix

    ../config/global/prelude.nix
    (../config + ("/" + profile.user.config) + "/prelude.nix")
  ];

  home.sessionVariables = {
    EDITOR = profile.user.editor;
    BROWSER = profile.user.browser;
    TERMINAL = profile.user.terminal;
  };

}
