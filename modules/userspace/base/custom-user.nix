{ username, settings, ... }:

{
  imports = [
    ./common.nix
    ../../../profiles/${settings.config.profile}/homes/${username}.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = settings.system.version;
}
