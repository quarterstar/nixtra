{ createCommand, profile, ... }:

createCommand {
  name = "rebuild";

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
    rm -rf /home/${profile.user.username}/.cache/nix/tarball-cache # Workaround fix for root ownership permission issue
    nixos-rebuild switch --flake /etc/nixos#default "$@"
  '';
}
