{ pkgs, ... }:

{
  home.packages = with pkgs; [ simplex-chat-desktop ];
}
