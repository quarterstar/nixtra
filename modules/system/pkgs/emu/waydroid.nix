{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    waydroid
  ];
}
