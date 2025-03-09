{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    torsocks
  ];
}
