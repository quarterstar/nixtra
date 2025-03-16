{ settings, profile, ... }:

{
  imports = [
    ./common.nix
    ../../../profiles/${settings.config.profile}/home-user.nix
  ];

  home.username = profile.user.username;
  home.homeDirectory = "/home/${profile.user.username}";
  home.stateVersion = settings.system.version;
}
