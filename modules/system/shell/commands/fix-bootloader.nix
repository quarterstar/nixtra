{ pkgs, profile, createCommand, ... }:

createCommand {
  inherit pkgs;
  inherit profile;
  name = "fix-bootloader";
  buildInputs = [];

  command = ''
    ${profile.shell.commands.prefix}-regen-hardware
    ${profile.shell.commands.prefix}-rebuild
    ${profile.shell.commands.prefix}-regen-bootloader
  '';
}
