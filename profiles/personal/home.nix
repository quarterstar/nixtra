{ settings, profile, config, pkgs, ... }:

{
  home.username = profile.user.username;
  home.homeDirectory = "/home/${profile.user.username}";
  home.stateVersion = settings.system.version;

  imports = [
    ../../modules/userspace/base.nix

    # Dependencies
    ../program/home.nix
    ../math/home.nix
    ../gaming/home.nix

    # Config
    ../../modules/userspace/config/hyprland/quarterstar/hypr.nix
    ../../modules/userspace/config/hyprland/quarterstar/waybar.nix
    ../../modules/userspace/config/hyprland/quarterstar/rofi.nix

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
