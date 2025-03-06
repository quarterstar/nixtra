{ pkgs, ... }:

{
  # Set extra functionality for `pkgs`
  nixpkgs.overlays = [
    (import ./overlays/commands.nix)
    (import ./overlays/sandbox.nix)
  ];
}
