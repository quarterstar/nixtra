{ settings, profile, config, pkgs, ... }:

{
  imports = [
    # Dependencies
    ../program/home-user.nix
    ../math/home-user.nix
    ../gaming/home-user.nix

    # Modules
    ../../modules/userspace/pkgs/torrent/qbittorrent.nix
    ../../modules/userspace/pkgs/video/vlc.nix
    ../../modules/userspace/pkgs/password/keepassxc.nix
    ../../modules/userspace/pkgs/drawing/krita.nix
    ../../modules/userspace/pkgs/aesthetic/fastfetch.nix
    ../../modules/userspace/pkgs/aesthetic/hollywood.nix
  ];

  programs.home-manager.enable = true;
}
