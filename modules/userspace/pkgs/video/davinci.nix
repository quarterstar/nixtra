{ unstable-pkgs, ... }:

{
  home.packages = with unstable-pkgs; [ davinci-resolve ];
}
