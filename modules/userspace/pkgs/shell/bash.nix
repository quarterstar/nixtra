{ config, ... }:

{
  programs.bash.enable = true;

  programs.bash.initExtra = if config.nixtra.shell.fastfetchOnStartup then ''
    fastfetch
  '' else
    "";
}
