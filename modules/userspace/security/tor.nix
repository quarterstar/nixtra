{ profile, pkgs, ... }:

{
  # In addition to shell alias, replace chosen programs
  # with a stub so that GUI applications use the replaced
  # program.
  home.packages = map (program:
    let
      programName = builtins.baseNameOf program.program;
      torifiedName = "${programName}-tor";
    in (pkgs.writeScriptBin torifiedName ''exec ${pkgs.torsocks}/bin/torsocks ${program.program} "$@"'')
  ) (builtins.filter (program: program.hardAlias) (profile.tor.aliases.programs pkgs));
}
