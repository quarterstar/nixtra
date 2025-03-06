{ pkgs, ... }:

{
  home.file = {
    ".config/lvim/config.lua" = {
      source = ../../../../config/global/lvim/config.lua;
      executable = false;
      force = true;
    };
  };
}
