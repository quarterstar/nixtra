{ profile, ... }:

{
  programs.bash.enable = true;

  programs.bash.initExtra = if profile.shell.fastfetchOnStartup then ''
    fastfetch
  '' else
    "";
}
