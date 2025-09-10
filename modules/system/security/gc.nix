{ config, ... }:

{
  nix.gc = {
    options = "--delete-older-than 14d";
    automatic = true;
    randomizedDelaySec = "45min";
    dates = "weekly";
  };
}
