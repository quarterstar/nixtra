{ inputs, config, pkgs, ... }:

{
  imports = [
    ./untracked.nix

    # Bundles
    ../../modules/system/bundles/gaming.nix
    ../../modules/system/bundles/programming.nix

    # Programs & Packages

    # Services
    ../../modules/system/services/opensnitch.nix
  ];
}
