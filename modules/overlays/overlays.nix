{ pkgs, ... }:

{
  # Set extra functionality for `pkgs`
  nixpkgs.overlays =
    [ (import ./commands.nix) (import ./sandbox.nix) (import ./number.nix) ];
}
