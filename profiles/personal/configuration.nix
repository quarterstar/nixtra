{ inputs, config, pkgs, ... }:

{
  imports = [
    ../../modules/system/bundles/gaming.nix
    ../../modules/system/bundles/program.nix
    #../untrusted/configuration.nix

    # Services
    ../../modules/system/services/opensnitch.nix
  ];
}
