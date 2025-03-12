{ profile, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

      oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" "copydir" "copyfile" "copybuffer" "dirhistory" "zsh-reload" "history" ];
      theme = "robbyrussell";
    };

    shellInit = if profile.shell.fastfetchOnStartup then ''
      fastfetch
    '' else "";
    
    #history.size = 10000;
  };
}
