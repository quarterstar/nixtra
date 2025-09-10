{ nixtraLib, pkgs, ... }:

let inherit (nixtraLib.command) createCommand;
in {
  home.packages =
    [ (pkgs.callPackage ./schedule-reminder.nix { inherit createCommand; }) ];
}
