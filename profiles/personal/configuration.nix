{ inputs, config, pkgs, ... }:

{
  imports = [
    # Dependencies
    ../gaming/configuration.nix
    ../program/configuration.nix
    ../untrusted/configuration.nix
    #../../modules/userspace/services/fix-permissions.sh
  ];
}
