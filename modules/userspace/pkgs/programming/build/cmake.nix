{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cmake
    clang-tools
  ];
}
