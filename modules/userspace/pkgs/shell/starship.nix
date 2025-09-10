{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ starship ];

  programs.starship.enable = true;
  programs.starship.settings = { format = "  $all"; };
}
