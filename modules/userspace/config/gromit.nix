{ config, pkgs, ... }:

{
  home.file = {
    ".config/gromit-mpx.ini" = {
      text = ''
        [General]
        ShowIntroOnStartup=false
      '';
      executable = false;
      force = true;
    };
  };
}
