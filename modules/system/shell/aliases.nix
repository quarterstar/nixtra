{ profile, lib, ... }:

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

  environment.shellAliases = {
    rm = "trash";
    neofetch = "fastfetch";
  } // torAliases;
}
