{ config, createCommand, ... }:

createCommand {
  name = "build-iso";

  command = ''
    set -e
    ORIGINAL_DIR="$(pwd)"
    trap 'cd "$ORIGINAL_DIR"' EXIT

    cd /etc/nixos
    git add --intent-to-add .
    if command -v "nixfmt" &> /dev/null; then
      nixfmt modules
    fi
    cd - > /dev/null
    rm -rf /home/${config.nixtra.user.username}/.cache/nix/tarball-cache # Workaround fix for root ownership permission issue
    mkdir -p /etc/nixos/dist
    nix build /etc/nixos#nixosConfigurations.iso.config.system.build.images.iso -o /etc/nixos/dist/iso
  '';
}
