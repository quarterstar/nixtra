{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    git-filter-repo # Rewrite Git repositories;
    gh
  ];
}
