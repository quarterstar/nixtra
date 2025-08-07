{ settings, profile, pkgs, ... }:

if profile.security.overwriteSudoWithDoas then {
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraConfig = ''
      permit persist :wheel
    '';
  };

  security.doas.extraRules = [
    {
      users = [ "${profile.user.username}" ];
      keepEnv = true;
      persist = true;
    }
    {
      users = [ "${profile.user.username}" ];
      cmd = "tee";
      noPass = true;
    }
  ];

  environment.systemPackages =
    [ (pkgs.writeScriptBin "sudo" ''exec doas "$@"'') ];
} else {
  security.sudo.enable = true;
}
