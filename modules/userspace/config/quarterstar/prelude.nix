{ ... }:

{
  imports = [
    ./terminal/kitty.nix
    ./shell/zsh.nix
    ./editor/lunarvim.nix
    ./video/freetube.nix
    ./wm/hyprland/hypr.nix
    ./wm/hyprland/rofi.nix
    ./wm/hyprland/waybar.nix
    ./theme/gtk.nix
    ../../pkgs/aesthetic/nwg-look.nix
  ];
}
