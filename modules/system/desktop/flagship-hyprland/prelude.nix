{ config, lib, pkgs, ... }:

{
  imports = [ ./login/sddm.nix ./theme/gtk.nix ./theme/qt.nix ];
}
