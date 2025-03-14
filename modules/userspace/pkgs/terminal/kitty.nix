{ profile, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty.enable = true;

  programs.kitty.settings = {
    shell = profile.user.shell;
    background_opacity = 0.25;
    dynamic_background_opacity = true;
    confirm_os_window_close = 0;
  };

  programs.bash.bashrcExtra = "export TERM=\"xterm-256color\"";
}
