{ config, pkgs, ... }:

{
  imports = [
    ../../../modules/userspace/pkgs/browser/librewolf/default.nix
    ../../../modules/userspace/pkgs/browser/chatgpt-container.nix
    ../../../modules/userspace/pkgs/notes/zettlr.nix
    ../../../modules/userspace/pkgs/reading/okular.nix
    ../../../modules/userspace/pkgs/reading/kiwix.nix
    ../../../modules/userspace/pkgs/drawing/openboard.nix
    ../../../modules/userspace/pkgs/programming/lang/python.nix
    ../../../modules/userspace/pkgs/audio/alsa.nix
  ];

  programs.home-manager.enable = true;
}
