{ profile, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    git-filter-repo # Rewrite Git repositories; 
    gh
  ];

  programs.git.enable = true;
  programs.git.config = {
    http = if profile.git.useTorProxy then {
      proxy = "socks5://127.0.0.1:9050";
    } else {};

    https = if profile.git.useTorProxy then {
      proxy = "socks5://127.0.0.1:9050";
    } else {};
  };
}
