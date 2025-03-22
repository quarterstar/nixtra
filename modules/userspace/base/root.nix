{ settings, profile, ... }:

{
  imports = [
    ./common.nix
    ../../../profiles/${settings.config.profile}/homes/root.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = settings.system.version;
}
