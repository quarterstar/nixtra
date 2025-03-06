{ inputs, config, pkgs, ... }:

{
  imports = [
    ../../modules/system/shell/aliases.nix

    # Dependencies
    ../program/configuration.nix
    ../untrusted/configuration.nix
  ];
}
