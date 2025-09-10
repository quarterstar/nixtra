{ config, createCommand, ... }:

createCommand {
  name = "fix-bootloader";
  buildInputs = [ ];

  command = ''
    ${config.nixtra.shell.commands.prefix}-regen-hardware
    ${config.nixtra.shell.commands.prefix}-rebuild
    ${config.nixtra.shell.commands.prefix}-regen-bootloader
  '';
}
