{ pkgs, ... }:

let
  rustupOverlay = self: super: {
    rustup = super.rustup.overrideAttrs (oldAttrs: {
      postInstall = ''
        ${oldAttrs.postInstall or ""}
        $out/bin/rustup component add rust-analyzer
      '';
    });
  };
in {
  nixpkgs.overlays = [
    rustupOverlay
  ];

  home.packages = with pkgs; [
    rustup
    trunk
    rustc
  ];
}
