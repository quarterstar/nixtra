self: super: {
  wrapFirejail = { executable, desktop ? null, profile ? null, extraArgs ? [] }:
    let
      profilePath = if profile != null then (builtins.toString ../../firejail + ("/" + profile) + ".profile") else null;
    in
    super.runCommand "firejail-wrap"
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        meta.priority = -1; # Take precedence over non-firejailed versions.
      }
      (
        let
          firejailArgs = super.lib.concatStringsSep " " (
            extraArgs ++ (super.lib.optional (profile != null) "--profile=${profilePath}")
          );
        in
        ''
          command_path="$out/bin/$(basename ${executable})"
          mkdir -p $out/bin
          mkdir -p $out/share/applications
          cat <<'_EOF' >"$command_path"
          #! ${super.runtimeShell} -e
          exec /run/wrappers/bin/firejail ${firejailArgs} -- ${toString executable} "$@"
          _EOF
          chmod 0755 "$command_path"
        '' + super.lib.optionalString (desktop != null) ''
          substitute ${desktop} $out/share/applications/$(basename ${desktop}) \
            --replace ${executable} "$command_path"
        ''
      );
}
