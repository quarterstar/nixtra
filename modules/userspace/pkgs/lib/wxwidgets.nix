{ pkgs, ... }:

{
  home.packages = with pkgs; [ wxGTK32 ];
}
