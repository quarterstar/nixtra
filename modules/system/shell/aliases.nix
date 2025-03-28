{ profile, pkgs, lib, ... }:

let
  # Function to generate shell aliases
  torAliases = 
    if profile.tor.aliases.enable then lib.listToAttrs (map (program: {
      name = program.name;
      value = "torsocks ${program.name}";
    }) (builtins.filter (program: !program.hardAlias) profile.tor.aliases.programs)) else {};
in {
  imports = [
    ../pkgs/cli/security.nix
  ];

  environment.shellAliases = (profile.shell.aliases pkgs) // torAliases;

  # In addition to shell alias, replace chosen programs
  # with a stub so that GUI applications use the replaced
  # program.
  environment.systemPackages = map (program:
    (pkgs.writeScriptBin program.name ''exec torsocks ${program.name} "$@"'')
  ) (builtins.filter (program: program.hardAlias) profile.tor.aliases.programs);
}
