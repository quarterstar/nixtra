{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ termusic ];
}
