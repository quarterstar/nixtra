{ config, pkgs, ... }:

{
  imports = [
    # Modules
    ../../../modules/userspace/pkgs/browser/librewolf.nix
    ../../../modules/userspace/pkgs/browser/tor.nix
    ../../../modules/userspace/pkgs/notes/zettlr.nix
    ../../../modules/userspace/pkgs/text/office.nix
    ../../../modules/userspace/pkgs/reading/okular.nix
    ../../../modules/userspace/pkgs/drawing/openboard.nix
    # ../../../modules/userspace/pkgs/drawing/drawio.nix
    ../../../modules/userspace/pkgs/social/element.nix
    ../../../modules/userspace/pkgs/programming/lang/python.nix
    ../../../modules/userspace/pkgs/programming/lang/java.nix
    ../../../modules/userspace/pkgs/programming/lang/node.nix
    ../../../modules/userspace/pkgs/programming/lang/rust.nix
    ../../../modules/userspace/pkgs/programming/lang/c.nix
    ../../../modules/userspace/pkgs/programming/build/cmake.nix
    # ../../../modules/userspace/pkgs/programming/ide/jetbrains.nix
    ../../../modules/userspace/pkgs/programming/ide/codium.nix
    ../../../modules/userspace/pkgs/api/insomnia.nix
    ../../../modules/userspace/pkgs/cli/tldr.nix
    ../../../modules/userspace/pkgs/cli/git.nix
    ../../../modules/userspace/pkgs/monitoring/htop.nix
    ../../../modules/userspace/pkgs/editor/lunarvim.nix
    ../../../modules/userspace/pkgs/editor/neovim.nix
    ../../../modules/userspace/pkgs/video/freetube.nix
    ../../../modules/userspace/pkgs/audio/alsa.nix
    ../../../modules/userspace/pkgs/re/ghidra.nix
    ../../../modules/userspace/pkgs/sandbox/virt-manager.nix
    ../../../modules/userspace/pkgs/lib/wxwidgets.nix
    ../../../modules/userspace/pkgs/ai/ollama.nix
    ../../../modules/userspace/pkgs/forensics/binwalk.nix
    ../../../modules/userspace/pkgs/schedule/calcurse.nix
    ../../../modules/userspace/pkgs/music/termusic.nix
    ../../../modules/userspace/pkgs/music/cava.nix
    ../../../modules/userspace/pkgs/file/dolphin.nix
    ../../../modules/userspace/pkgs/file/pcmanfm.nix
    ../../../modules/userspace/pkgs/compression/p7zip.nix
    ../../../modules/userspace/pkgs/proxy/proxychains.nix
    ../../../modules/userspace/pkgs/aesthetic/lxappearance.nix
  ];

  home.packages = [
  ];

  programs.home-manager.enable = true;
}
