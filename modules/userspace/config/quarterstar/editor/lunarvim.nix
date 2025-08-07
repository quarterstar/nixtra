{ profile, pkgs, ... }:

{
  home.file = {
    ".config/lvim/config.lua" = {
      source =
        ../../../../../config/${profile.user.config}/editor/lunarvim/config.lua;
      executable = false;
      force = true;
    };
  };
}
