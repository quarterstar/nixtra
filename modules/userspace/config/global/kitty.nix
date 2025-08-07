{ pkgs, profile, ... }:

{
  programs.kitty.extraConfig = if profile.shell.ai_integration then
    let
      kittyai = (pkgs.callPackage ../../../../packages/kittyai/default.nix { });
    in ''
      map kitty_mod+i kitten bash -c "exec ${kittyai}/bin/kittyai"
    ''
  else
    "";
}
