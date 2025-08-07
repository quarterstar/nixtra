{ runCommand, runtimeShell, config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../../modules/userspace/pkgs/games/minecraft/prismlauncher.nix
    #../../../modules/userspace/pkgs/games/roblox.nix
    #../../../modules/userspace/pkgs/emu/cemu.nix
    ../../../modules/userspace/pkgs/emu/ryujinx.nix
    ../../../modules/userspace/pkgs/emu/wine.nix
    ../../../modules/userspace/pkgs/emu/bottles.nix
    ../../../modules/userspace/pkgs/browser/librewolf.nix
    ../../../modules/userspace/pkgs/notes/zettlr.nix
    ../../../modules/userspace/pkgs/audio/alsa.nix
    ../../../modules/userspace/pkgs/virt/virtualbox.nix
    ../../../modules/userspace/pkgs/virt/virtualbox.nix
    ../../../modules/userspace/pkgs/performance/gamescope.nix
    ../../../modules/userspace/pkgs/social/dissent.nix
  ];

  home.packages = [
    (pkgs.wrapFirejail {
      #executable = (pkgs.torify "${pkgs.prismlauncher}/bin/prismlauncher");
      executable = "${pkgs.prismlauncher}/bin/prismlauncher";
      profile = "prismlauncher";
    })
  ];

  programs.home-manager.enable = true;
}
