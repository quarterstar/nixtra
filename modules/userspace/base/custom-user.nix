{ username, ... }:

{
  imports = [
    ./common.nix
    ../../../profiles/${config.nixtra.config.profile}/homes/${username}.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = config.nixtra.system.version;
}
