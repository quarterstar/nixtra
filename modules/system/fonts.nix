{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    font-awesome
    cm_unicode # Computer Modern font
  ];
}
