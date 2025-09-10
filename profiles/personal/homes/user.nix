{ settings, profile, config, pkgs, ... }:

{
  imports = [
    ../../../modules/userspace/bundles/program.nix
    ../../../modules/userspace/bundles/math.nix
    ../../../modules/userspace/bundles/gaming.nix

    ../../../modules/userspace/pkgs/torrent/qbittorrent.nix
    ../../../modules/userspace/pkgs/video/vlc.nix
    ../../../modules/userspace/pkgs/video/mpv.nix
    ../../../modules/userspace/pkgs/video/obs.nix
    ../../../modules/userspace/pkgs/video/owncast.nix
    ../../../modules/userspace/pkgs/editor/kdenlive.nix
    ../../../modules/userspace/pkgs/password/keepassxc.nix
    ../../../modules/userspace/pkgs/drawing/krita.nix
    ../../../modules/userspace/pkgs/drawing/gromit.nix
    ../../../modules/userspace/pkgs/aesthetic/fastfetch.nix
    ../../../modules/userspace/pkgs/aesthetic/hollywood.nix
    ../../../modules/userspace/pkgs/social/simplex-chat.nix
    ../../../modules/userspace/pkgs/image/swayimg.nix
    ../../../modules/userspace/pkgs/security/opensnitch.nix
  ];

  #home.packages = [
    #(pkgs.callPackage ../../../packages/davinci-resolve/default.nix { studioVariant = true; })
    #(pkgs.callPackage ../../../packages/cake_wallet/default.nix {})
  #];

  programs.home-manager.enable = true;
}
