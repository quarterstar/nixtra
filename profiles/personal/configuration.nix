{ inputs, config, pkgs, ... }:

{
  imports = [
    # Dependencies
    ../program/configuration.nix
    ../untrusted/configuration.nix
  ];
}
