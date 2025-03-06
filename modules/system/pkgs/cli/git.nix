{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    git-filter-repo # Rewrite Git repositories; 
    gh
  ];
}
