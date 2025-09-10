{ config, pkgs, ... }:

{
  fonts = {
    packages = with pkgs;
      [
        # Packed fonts
        font-awesome

        # Common fonts
        #dejavu_fonts
        #roboto
        #liberation_ttf
        #open-sans
        #inter
        #overpass

        # CJK fonts
        #noto-fonts
        #noto-fonts-cjk-sans
        #noto-fonts-cjk-serif
        #noto-fonts-emoji
        #wqy_microhei
        #lxgw-wenkai
        #lxgw-neoxihei

        # Coding fonts
        #jetbrains-mono
        #roboto-mono
        #ibm-plex
        #camingo-code
        #victor-mono
        #iosevka
        #source-code-pro
        #cascadia-code
        #fira-code
      ];
  };
}
