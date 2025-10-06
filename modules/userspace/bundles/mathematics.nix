{ config, ... }:

{
  imports = [
    ../pkgs/browser/librewolf/default.nix
    ../pkgs/browser/chatgpt-container.nix
    ../pkgs/notes/zettlr.nix
    ../pkgs/reading/okular.nix
    ../pkgs/reading/kiwix.nix
    ../pkgs/drawing/openboard.nix
    ../pkgs/programming/lang/python.nix
    ../pkgs/audio/alsa.nix
    ../pkgs/learning/anki.nix
  ];
}
