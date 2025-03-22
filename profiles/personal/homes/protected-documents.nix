{ pkgs, ... }:

{
  imports = [
    ../../../modules/userspace/pkgs/text/office.nix
    ../../../modules/userspace/pkgs/editor/lunarvim.nix
    ../../../modules/userspace/pkgs/programming/lang/java.nix
  ];

  home.packages = [
    #(pkgs.wrapFirejail {
    #  executable = "${pkgs.libreoffice}/bin/libreoffice";
    #  profile = "libreoffice";
    #})
  ];
}
