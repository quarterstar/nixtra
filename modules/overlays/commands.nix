self: super: {
  createCommand = { name, command, buildInputs ? [], ... }:
    let
      script = super.writeScript "${profile.shell.commands.prefix}-${name}" command;
      settings = import ../../settings.nix;
      profile = import ../../profiles/${settings.config.profile}/profile-settings.nix;
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
