{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    git-filter-repo # Rewrite Git repositories;
    gh
  ];

  home.file.".gdbinit".text = ''
    set disassembly-flavor intel
  '';
}
