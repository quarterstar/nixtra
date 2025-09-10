{ lib, pkgs, config, settings, ... }:

{
  # TODO: update scripts to change strictFailure to true
  createCommand = { name, prefix ? "${config.nixtra.shell.commands.prefix}"
    , command, buildInputs ? [ ], strictFailure ? false, requireRoot ? false
    , ... }:
    let
      pname = if prefix != "" then "${prefix}-${name}" else "${name}";
      script = pkgs.writeScript "${pname}" ''
        #!/usr/bin/env bash

        ${if strictFailure then ''
          set -euo pipefail
        '' else
          ""}

        ${if requireRoot then ''
          if [ "$(id -u)" -ne 0 ]; then
            printf 'ERROR: this script must be run as root.\n' >&2
            printf 'Run: sudo %s <args>\n' "$0" >&2
            exit 1
          fi
        '' else
          ""}

        ${command}'';
    in pkgs.stdenv.mkDerivation {
      buildInputs = with pkgs; [ bash makeWrapper ] ++ buildInputs;

      name = pname;
      unpackPhase = "true";

      installPhase = ''
        mkdir -p $out/bin
        cp ${script} $out/bin/${pname}
        chmod +x $out/bin/${pname}
        wrapProgram $out/bin/${pname} --prefix PATH : ${
          pkgs.lib.makeBinPath buildInputs
        }
      '';
    };
}
