{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #rkhunter
    lynis
    clamav
  ];
}
