{ config, ... }:

{
  imports = [
    # Modules
    ../pkgs/browser/librewolf/default.nix
    ../pkgs/browser/chatgpt-container.nix
    ../pkgs/browser/tor/tor.nix
    ../pkgs/notes/zettlr.nix
    ../pkgs/notes/planify.nix
    ../pkgs/text/office.nix
    ../pkgs/reading/okular.nix
    ../pkgs/reading/kiwix.nix
    ../pkgs/reading/newsflash.nix
    ../pkgs/drawing/openboard.nix
    # ../pkgs/drawing/drawio.nix
    ../pkgs/social/element.nix
    ../pkgs/social/dissent.nix
    ../pkgs/emu/wine.nix
    ../pkgs/emu/bottles.nix
    ../pkgs/programming/lang/python.nix
    ../pkgs/programming/lang/java.nix
    ../pkgs/programming/lang/node.nix
    ../pkgs/programming/lang/rust.nix
    ../pkgs/programming/lang/c.nix
    ../pkgs/programming/lang/latex.nix
    ../pkgs/programming/build/cmake.nix
    # ../pkgs/programming/ide/jetbrains.nix
    ../pkgs/programming/ide/codium.nix
    ../pkgs/api/insomnia.nix
    ../pkgs/cli/tldr.nix
    ../pkgs/cli/git.nix
    ../pkgs/monitoring/htop.nix
    ../pkgs/editor/lunarvim.nix
    ../pkgs/editor/neovim.nix
    ../pkgs/video/freetube.nix
    ../pkgs/audio/alsa.nix
    ../pkgs/re/ghidra.nix
    ../pkgs/sandbox/virt-manager.nix
    ../pkgs/lib/wxwidgets.nix
    ../pkgs/ai/ollama.nix
    ../pkgs/forensics/binwalk.nix
    ../pkgs/forensics/volatility.nix
    ../pkgs/forensics/foremost.nix
    ../pkgs/forensics/autopsy.nix
    ../pkgs/forensics/zsteg.nix
    ../pkgs/schedule/calcurse.nix
    ../pkgs/music/termusic.nix
    ../pkgs/music/cava.nix
    ../pkgs/file/dolphin.nix
    ../pkgs/file/pcmanfm.nix
    ../pkgs/compression/p7zip.nix
    ../pkgs/compression/unzip.nix
    ../pkgs/proxy/proxychains.nix
    ../pkgs/aesthetic/lxappearance.nix
    ../pkgs/electronics/logisim-evolution.nix
  ];
}
