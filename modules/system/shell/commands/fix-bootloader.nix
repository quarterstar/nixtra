{ profile, createCommand, ... }:

createCommand {
  name = "fix-bootloader";
  buildInputs = [];

  command = ''
    ${profile.shell.commands.prefix}-regen-hardware
    ${profile.shell.commands.prefix}-rebuild
    ${profile.shell.commands.prefix}-regen-bootloader
  '';
}
