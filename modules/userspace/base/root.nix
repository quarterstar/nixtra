{ settings, profile, ... }:

{
  imports = [
    ./common.nix
    ../../../profiles/${settings.config.profile}/home-root.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = settings.system.version;
}
