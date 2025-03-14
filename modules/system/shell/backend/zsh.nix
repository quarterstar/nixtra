{ profile, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "copyfile" "copybuffer" "dirhistory" "history" ];
      theme = "robbyrussell";
    };
  };
}
