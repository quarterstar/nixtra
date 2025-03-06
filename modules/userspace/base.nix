{ runCommand, runtimeShell, lib, profile, pkgs, ... }:

{
  imports = [
    (./pkgs/terminal + ("/" + profile.user.terminal) + ".nix") 
    ./theme/type.nix
  ];
}
