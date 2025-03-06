{ pkgs, ... }:

{
  home.packages = with pkgs; [
    marktext
  ];
}
