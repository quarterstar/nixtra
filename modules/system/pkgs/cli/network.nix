{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    wget
    dig
    netcat-gnu
    wireshark
  ];
}
