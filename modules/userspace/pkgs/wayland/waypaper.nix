{ pkgs, nixtraLib, ... }:

{
  home.packages = with pkgs; [
    (nixtraLib.sandbox.wrapFirejail {
      executable = "${pkgs.waypaper}/bin/waypaper";
      profile = "waypaper";
    })
    waypaper
  ];
}
