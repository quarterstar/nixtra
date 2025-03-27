{ pkgs, ... }: let
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
in {
  environment.systemPackages = [ sddm-quarterstar ];

  services.displayManager.sddm = {
    theme = "quarterstar";
  };
}
