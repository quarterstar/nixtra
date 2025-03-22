{ runCommand, runtimeShell, config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../../modules/userspace/pkgs/games/minecraft/prismlauncher.nix
    #../../../modules/userspace/pkgs/emu/cemu.nix
    ../../../modules/userspace/pkgs/emu/ryujinx.nix
    ../../../modules/userspace/pkgs/emu/wine.nix
    ../../../modules/userspace/pkgs/browser/librewolf.nix
    ../../../modules/userspace/pkgs/notes/zettlr.nix
    ../../../modules/userspace/pkgs/audio/alsa.nix
    ../../../modules/userspace/pkgs/virt/virtualbox.nix
  ];

  home.packages = with pkgs; [
    (pkgs.wrapFirejail {
      executable = "${pkgs.prismlauncher}/bin/prismlauncher";
      profile = "prismlauncher";
    })
  ];

  programs.home-manager.enable = true;
}
