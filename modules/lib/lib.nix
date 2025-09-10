{ config, settings, lib, pkgs, ... }:

{
  option = import ./option.nix { inherit lib pkgs; };
  command = import ./command.nix { inherit pkgs lib settings config; };
  sandbox = import ./sandbox.nix { inherit pkgs; };
  number = import ./number.nix { inherit pkgs; };
  loader = import ./loader.nix { inherit config lib pkgs; };
}
