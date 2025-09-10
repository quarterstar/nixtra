{ config, pkgs, ... }:

{
  home.file = {
    ".gnupg/gpg-agent.conf" = {
      text = ''
        debug-pinentry
        debug ipc
        verbose
        enable-ssh-support
        pinentry-program /run/current-system/sw/bin/pinentry
      '';
      executable = false;
      force = true;
    };
  };
}
