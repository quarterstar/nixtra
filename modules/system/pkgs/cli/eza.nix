{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ eza ];
}
