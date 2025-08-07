{ pkgs, ... }:

{
  home.packages = with pkgs;
    [
      #python312Full
      #python312Packages.pip

      (pkgs.python312.withPackages
        (ppkgs: [ ppkgs.openai ppkgs.python-dotenv ]))
    ];
}
