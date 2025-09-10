{ nixtraLib, config, pkgs, lib, ... }:

{
  imports = [
    ./programs/shell/zsh.nix
    ./programs/theme/qt.nix
    ./programs/theme/gtk.nix

    ../../../pkgs/aesthetic/nwg-look.nix
  ];

  config.nixtra = { user = { shell = lib.mkDefault "zsh"; }; };
}
