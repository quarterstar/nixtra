self: super: {
  createCommand = { profile, name, command, buildInputs ? [], ... }:
    let
      script = super.writeScript "${profile.shell.commands.prefix}-${name}" command;
    in
      super.stdenv.mkDerivation {
        inherit buildInputs;

        name = "${profile.shell.commands.prefix}-${name}";
        unpackPhase = "true";

        installPhase = ''
          mkdir -p $out/bin
          cp ${script} $out/bin/${profile.shell.commands.prefix}-${name}
          chmod +x $out/bin/${profile.shell.commands.prefix}-${name}
        '';
      };
}
