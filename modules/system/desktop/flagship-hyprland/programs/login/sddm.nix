{ config, lib, pkgs, ... }:

let
  sddm-quarterstar = pkgs.stdenv.mkDerivation {
    name = "sddm-quarterstar";
    dontBuild = true;
    src = pkgs.fetchFromGitLab {
      owner = "Matt.Jolly";
      repo = "sddm-eucalyptus-drop";
      rev = "0b82ca465b7dac6d7ff15ebaf1b2f26daba5d126";
      sha256 = "sha256-SUOqcK7fGb5OnWmB4Wenqr9PPiagYUoEHjLd5CM6fyk=";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/quarterstar
    '';
  };

  tokyo-night-sddm =
    pkgs.libsForQt5.callPackage ../../packages/sddm-theme/default.nix { };
in {
  config = lib.mkIf (config.nixtra.user.desktop == "flagship-hyprland") {
    environment.systemPackages = [ tokyo-night-sddm ];

    services.displayManager.sddm = {
      enable = true;
      theme = "tokyo-night-sddm";
    };
  };
}
