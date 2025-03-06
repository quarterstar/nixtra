{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty.enable = true;
  programs.kitty.extraConfig = ''
    background_opacity  0.25
    dynamic_background_opacity  yes
  '';

  programs.bash.bashrcExtra = "export TERM=\"xterm-256color\"";
}
