{ pkgs, ... }:

{
  home.packages = with pkgs; [
    proxychains
  ];
}
