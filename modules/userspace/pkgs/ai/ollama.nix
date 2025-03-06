{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ollama
  ];

  programs.bash.bashrcExtra = "export OLLAMA_MODELS=\"/mnt/data/models\"";
}
