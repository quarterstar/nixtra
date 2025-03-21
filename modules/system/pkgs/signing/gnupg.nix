{ pkgs, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry
    #pinentry-curses
  ];

  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    #pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };
}
