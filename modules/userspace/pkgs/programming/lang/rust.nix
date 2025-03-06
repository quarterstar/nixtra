{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustup
    trunk
    rustc
  ];
}
