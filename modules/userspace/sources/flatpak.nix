{ profile, lib, pkgs, ... }:

if profile.flatpak.enable then
{
  home.packages = with pkgs; [
    flatpak
  ];

  home.activation = {
    installFlathub = lib.hm.dag.entryAfter [ "writeBoundary" ]
      (lib.concatStringsSep "\n" (map (source:
        "${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists ${source.name} ${source.source}"
      ) profile.flatpak.sources));

    installFlatpakPackages = lib.hm.dag.entryAfter [ "writeBoundary" ]
      (lib.concatStringsSep "\n" (map (app:
        let
          installCommand = 
            if builtins.hasAttr "source" app then
              "${pkgs.flatpak}/bin/flatpak install --user --assumeyes --noninteractive ${app.source} ${app.app}"
            else
              ''
                tmpdir=$(mktemp -d)
                ${pkgs.curl}/bin/curl -Lo "$tmpdir/app.flatpak" ${app.url}
                ${pkgs.flatpak}/bin/flatpak install --user --assumeyes --noninteractive "$tmpdir/app.flatpak"
                rm -rf "$tmpdir"
              '';
        in ''
          if ! ${pkgs.flatpak}/bin/flatpak list --app --user | grep -q ${app.app}; then
            ${installCommand}
          fi
        ''
      ) profile.flatpak.apps));
  };
} else {}
