{ pkgs, config, createCommand, ... }:

createCommand {
  name = "rebuild";

  buildInputs = with pkgs; [ openssl ];

  strictFailure = true;
  requiresRoot = true;

  command = ''
    ORIGINAL_DIR="$(pwd)"
    trap 'cd "$ORIGINAL_DIR"' EXIT

    # Backup configuration after successful rebuild
    BACKUP_DIR="/var/backups/nixos-backups"
    BACKUP_PW="stub-password-change-me" # <-- change this to a secure secret or integrate your key management
    MAX_KEEP=25

    # Ensure backup dir exists and is secure
    mkdir -p "$BACKUP_DIR"
    chown root:root "$BACKUP_DIR"
    chmod 700 "$BACKUP_DIR"

    cd /etc/nixos
    git add --intent-to-add .
    if command -v "nixfmt" &> /dev/null; then
      nixfmt modules
    fi
    cd - > /dev/null
    rm -rf /home/${config.nixtra.user.username}/.cache/nix/tarball-cache # Workaround fix for root ownership permission issue
    nixos-rebuild switch --flake /etc/nixos "$@"

    TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
    GITREV=$(git -C /etc/nixos rev-parse --short=8 2>/dev/null || echo unknown)
    BACKUP_NAME="nixos-backup-''${TIMESTAMP}-''${GITREV}.tar.gz.enc"
    BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

    # - tar: create gzipped tar of /etc/nixos (stored with relative paths)
    # - openssl: AES-256-CBC encryption with PBKDF2 (password-based)
    tar -C /etc -czf - nixos \
      | openssl enc -aes-256-cbc -pbkdf2 -salt -pass pass:"$BACKUP_PW" -out "$BACKUP_PATH"

    chmod 600 "$BACKUP_PATH"
    chown root:root "$BACKUP_PATH"

    # Rotation: keep only the most recent $MAX_KEEP backups, delete older ones.
    # This approach lists backups newest-first and removes entries from 26 onward.
    set -- "$BACKUP_DIR"/nixos-backup-*.tar.gz.enc
    if [ -e "$1" ]; then
      ls -1t "$BACKUP_DIR"/nixos-backup-*.tar.gz.enc \
        | tail -n +$((MAX_KEEP + 1)) \
        | while IFS= read -r oldf; do
            rm -f -- "$oldf" || true
          done
    fi

    echo "Backup written to: $BACKUP_PATH"
  '';
}
