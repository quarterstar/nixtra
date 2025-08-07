{ pkgs, ... }:

{
  home.packages = with pkgs; [ prismlauncher-unwrapped ];
}
