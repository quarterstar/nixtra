{ settings, profile, config, pkgs, ... }:

{
  imports = [
    # Dependencies
    ../../program/homes/user.nix
    ../../math/homes/user.nix
    ../../gaming/homes/user.nix

    # Modules
    ../../../modules/userspace/pkgs/torrent/qbittorrent.nix
    ../../../modules/userspace/pkgs/video/vlc.nix
    ../../../modules/userspace/pkgs/password/keepassxc.nix
    ../../../modules/userspace/pkgs/drawing/krita.nix
    ../../../modules/userspace/pkgs/aesthetic/fastfetch.nix
    ../../../modules/userspace/pkgs/aesthetic/hollywood.nix
  ];

  programs.home-manager.enable = true;
}
