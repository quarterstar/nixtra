{ osConfig, settings, ... }:

{
  imports = [
    #../../options.nix

    ./common.nix
    ../../../profiles/${settings.config.profile}/homes/root.nix

    #../desktop/flagship-hyprland/root/prelude.nix
    ../desktop/flagship-hyprland/global/prelude.nix
  ];

  config = {
    nixtra = osConfig.nixtra;
    home.username = "root";
    home.homeDirectory = "/root";
    home.stateVersion = settings.system.version;
  };

  options = { };
}
