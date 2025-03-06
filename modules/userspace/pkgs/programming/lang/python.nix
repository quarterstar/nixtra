{ pkgs, ... }:

{
  home.packages = with pkgs; [
    python312Full
    python312Packages.pip
    python312Packages.pycryptodome
  ];
}
