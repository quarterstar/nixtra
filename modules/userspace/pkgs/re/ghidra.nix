{ settings, inputs, pkgs, ... }:

{
  home.packages = with pkgs; [ ghidra ];
}
