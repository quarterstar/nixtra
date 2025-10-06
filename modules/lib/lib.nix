{ config, lib, pkgs, ... }:

{
  option = import ./option.nix { inherit lib pkgs; };
  command = import ./command.nix { inherit pkgs lib config; };
  sandbox = import ./sandbox.nix { inherit pkgs lib; };
  number = import ./number.nix { inherit pkgs; };
  loader = import ./loader.nix { inherit config lib pkgs; };
  shell = import ./shell.nix { inherit lib; };
}
