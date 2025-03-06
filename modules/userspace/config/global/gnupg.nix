{ pkgs, ... }:

{
  home.file = {
    ".gnupg/gpg-agent.conf" = {
      source = ../../../../config/global/gnupg/gpg-agent.conf;
      executable = false;
      force = true;
    };
  };
}
