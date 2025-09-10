{ pkgs, ... }: {
  wrapFirejail =
    { executable, desktop ? null, profile ? null, extraArgs ? [ ] }:
    let
      profilePath = if profile != null then
        (builtins.toString ../../firejail + ("/" + profile) + ".profile")
      else
        null;
    in pkgs.runCommand "firejail-wrap" {
      preferLocalBuild = true;
      allowSubstitutes = false;
      meta.priority = -1; # Take precedence over non-firejailed versions.
    } (let
      firejailArgs = pkgs.lib.concatStringsSep " " (extraArgs
        ++ (pkgs.lib.optional (profile != null) "--profile=${profilePath}"));
    in ''
      command_path="$out/bin/$(basename ${executable})"
      mkdir -p $out/bin
      mkdir -p $out/share/applications
      cat <<'_EOF' >"$command_path"
      #! ${pkgs.runtimeShell} -e
      exec /run/wrappers/bin/firejail ${firejailArgs} -- ${
        toString executable
      } "$@"
      _EOF
      chmod 0755 "$command_path"
    '' + pkgs.lib.optionalString (desktop != null) ''
      substitute ${desktop} $out/share/applications/$(basename ${desktop}) \
        --replace ${executable} "$command_path"
    '');

  torify = program:
    pkgs.writeShellScriptBin (builtins.baseNameOf program) ''
      exec ${pkgs.torsocks}/bin/torsocks ${program} "$@"
    '';
}
