{ config, pkgs, ... }:

{
  imports = [
    # Modules
    ../../../modules/userspace/pkgs/editor/lunarvim.nix
  ];

  programs.home-manager.enable = true;
}
