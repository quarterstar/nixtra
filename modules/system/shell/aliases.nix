{ profile, pkgs, lib, ... }:

let
  torAliases = 
    if profile.tor.aliases.enable then lib.listToAttrs (map (program: {
      name = builtins.baseNameOf program.program;
      value = "torsocks ${program.program}";
    }) (profile.tor.aliases.programs pkgs)) else {};
in {
  imports = [
    ../pkgs/cli/security.nix
  ];

  environment.shellAliases = (profile.shell.aliases pkgs) // torAliases;
}
