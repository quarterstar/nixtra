{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Static vulnerability analysis
    cppcheck
    flawfinder

    # Pentesting CLI tools
    routersploit
    nmap
    thc-hydra
    sqlmap
  ];
}
