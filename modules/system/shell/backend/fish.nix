{ config, ... }:

{
  programs.fish.enable = true;
  programs.fish.shellInit = if config.nixtra.shell.fastfetchOnStartup then ''
    fastfetch
  '' else
    "";
}
