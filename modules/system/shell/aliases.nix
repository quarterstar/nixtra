{ config, pkgs, lib, ... }:

let
  torAliases = if config.nixtra.tor.aliases.enable then
    lib.listToAttrs (map (program: {
      name = builtins.baseNameOf program.program;
      value = "torsocks ${program.program}";
    }) (config.nixtra.tor.aliases.programs))
  else
    { };
in {
  imports = [ ../pkgs/cli/security.nix ];

  environment.shellAliases = (config.nixtra.shell.aliases) // torAliases;
}
