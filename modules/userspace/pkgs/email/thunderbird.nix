{ pkgs, nixtraLib, ... }:

{
  home.packages = with pkgs; [
    (nixtraLib.sandbox.wrapFirejail {
      executable = "${pkgs.thunderbird}/bin/thunderbird";
      profile = "thunderbird";
    })
    thunderbird
  ];
}
