{ unstable-pkgs, ... }:

{
  home.packages = with unstable-pkgs; [ ollama ];

  programs.bash.bashrcExtra = ''export OLLAMA_MODELS="/mnt/data/models"'';
}
