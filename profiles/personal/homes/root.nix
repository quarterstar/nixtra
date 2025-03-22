{ settings, profile, config, pkgs, ... }:

{
  imports = [
    # Dependencies
    ../../program/homes/root.nix
  ];

  programs.home-manager.enable = true;
}
