{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rose-pine-cursor
    rose-pine-hyprcursor
  ];
}
