{ config, pkgs, lib, ... }:

let
  searchBytes = "\\x00\\x85\\xc0\\x74\\x7b\\xe8";
  replaceBytes = "\\x00\\x85\\xc0\\xEB\\x7b\\xe8";
  patchScript = ''
    perl -pi -e 's/${searchBytes}/${replaceBytes}/g' $out/bin/resolve
  '';

in {
  environment.systemPackages = [
    (pkgs.davinci-resolve-studio.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        echo "Applying binary patch to resolve..."
        # Make sure the binary exists and is writable for perl -pi
        if [ -f $out/bin/resolve ]; then
          chmod +w $out/bin/resolve
          ${patchScript}
          chmod -w $out/bin/resolve # Revert permissions
          echo "Binary patch applied successfully."
        else
          echo "Error: /bin/resolve not found in $out. Patch skipped." >&2
          exit 1
        fi
      '';
    }))
  ];
}
