{ settings, profile, pkgs, ... }:

{
  security.sudo.enable = false;
  security.doas.enable = true;

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

  environment.systemPackages = [
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
  ];
}
