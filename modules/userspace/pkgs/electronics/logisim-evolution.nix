{ pkgs, ... }:

{
  home.packages = with pkgs; [ logisim-evolution ];
}
