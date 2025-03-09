{ runCommand, runtimeShell, lib, profile, pkgs, ... }:

{
  imports = [
    (./pkgs/terminal + ("/" + profile.user.terminal) + ".nix") 
    ./theme/type.nix
  ];

  home.sessionVariables = {
    EDITOR = profile.user.editor;
    BROWSER = profile.user.browser;
    TERMINAL = profile.user.terminal;
  };
}
