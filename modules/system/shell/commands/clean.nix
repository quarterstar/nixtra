{ profile, pkgs, createCommand, ... }:

createCommand {
  name = "clean";
  buildInputs = with pkgs; [ bash ];

  command = ''
    #!${pkgs.bash}/bin/bash

    # Function to display a message with a timestamp
    log() {
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1"
    }

    log "Running garbage collection to remove unused packages..."
    nix-collect-garbage --delete-old
    if [ $? -eq 0 ]; then
      log "Garbage collection completed successfully."
    else
      log "Garbage collection failed. Please check for errors."
      exit 1
    fi

    log "Optimizing the Nix store..."
    nix-store --optimise
    if [ $? -eq 0 ]; then
      log "Nix store optimization completed successfully."
    else
      log "Nix store optimization failed. Please check for errors."
      exit 1
    fi

    log "Cleaning up temporary files..."
    find /tmp -type f -atime +7 -delete
    find /var/tmp -type f -atime +7 -delete
    log "Temporary files cleanup completed."

    log "Removing old system generations..."
    nix-env --delete-generations old
    if [ $? -eq 0 ]; then
      log "Old system generations removed successfully."
    else
      log "Failed to remove old system generations. Please check for errors."
      exit 1
    fi

    log "Cleaning up user profile generations..."
    nix-env --delete-generations old --profile /nix/var/nix/profiles/per-user/$USER/profile
    if [ $? -eq 0 ]; then
      log "User profile generations cleaned up successfully."
    else
      log "Failed to clean up user profile generations. Please check for errors."
      exit 1
    fi

    log "Cleaning up flake caches..."
    rm -rf ~/.cache/nix/eval-cache-v*
    rm -rf ~/.cache/nix/flake-registry.json
    log "Flake caches cleaned up."

    log "Cleaning up Nix build logs..."
    rm -rf /nix/var/log/nix/drvs/*
    log "Nix build logs cleaned up."

    log "Cleaning up old profiles..."
    nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"
    log "Old profiles cleaned up."

    log "Cleaning up Home Manager backup files..."
    find /home/${profile.user.username} -type f -name "*.hm.backup.*" -exec rm -f {} \;
    log "Home Manager backup files cleaned up."

    log "NixOS cleanup completed successfully!"
  '';
}
