{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ foremost ];
}
