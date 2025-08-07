{ profile, ... }:

{
  programs.fish.enable = true;
  programs.fish.shellInit = if profile.shell.fastfetchOnStartup then ''
    fastfetch
  '' else
    "";
}
