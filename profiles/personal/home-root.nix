{ settings, profile, config, pkgs, ... }:

{
  imports = [
    # Dependencies
    ../program/home-root.nix
  ];

  programs.home-manager.enable = true;
}
