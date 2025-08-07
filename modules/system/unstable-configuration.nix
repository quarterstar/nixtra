# Special configuration for packages that need to be installed from the nixpkgs unstable channel.
# Should not be used for most of the packages.

{ lib, profile, ... }:

{
  allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) profile.security.permittedUnfreePackages;
  permittedInsecurePackages = if !profile.security.networking then
    profile.security.permittedInsecurePackages
  else
    [ ];
}
