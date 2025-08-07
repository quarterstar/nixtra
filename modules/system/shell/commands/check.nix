{ createCommand, ... }:

createCommand {
  name = "check";

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
  '';
}
