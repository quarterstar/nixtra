{ profile, pkgs, lib, ... }:

let
  # Function to generate shell aliases
  torAliases = if profile.tor.aliases.enable then lib.listToAttrs (map (program: {
    name = program;
    value = "torsocks ${program}";
  }) profile.tor.aliases.programs) else {};
in {
  imports = [
    ../pkgs/cli/security.nix
  ];

  environment.shellAliases = profile.shell.aliases // torAliases;

  # In addition to shell alias, replace the program
  # with a stub so that GUI applications use the replaced
  # program.
  environment.systemPackages = (map (program: pkgs.writeScriptBin program ''exec torsocks ${program} "$@"'') profile.tor.aliases.programs);
}
