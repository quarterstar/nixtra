{ config, pkgs, ... }:

let
  settings = import ../settings.nix;
  profile = import ../profiles/${settings.config.profile}/profile-settings.nix;
in {
  home.username = profile.user.username;
  home.homeDirectory = "/home/${profile.user.username}";
  home.stateVersion = settings.system.version;

  imports = [
    ../profiles/${settings.config.profile}/home.nix
  ];
}
