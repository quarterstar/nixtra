{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ planify ];
}
