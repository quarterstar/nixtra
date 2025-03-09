{ pkgs, profile, createCommand, ... }:

createCommand {
  inherit pkgs;
  inherit profile;
  name = "clean";
  buildInputs = with pkgs; [ bash ];

  command = ''
    #!${pkgs.bash}/bin/bash

    # Function to display a message with a timestamp
    log() {
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1"
    }

    # Step 1: Remove unused packages from the Nix store
    log "Running garbage collection to remove unused packages..."
    nix-collect-garbage --delete-old
    if [ $? -eq 0 ]; then
      log "Garbage collection completed successfully."
    else
      log "Garbage collection failed. Please check for errors."
      exit 1
    fi

    # Step 2: Optimize the Nix store by hard-linking duplicate files
    log "Optimizing the Nix store..."
    nix-store --optimise
    if [ $? -eq 0 ]; then
      log "Nix store optimization completed successfully."
    else
      log "Nix store optimization failed. Please check for errors."
      exit 1
    fi

    # Step 3: Clean up temporary files in /tmp and /var/tmp
    log "Cleaning up temporary files..."
    find /tmp -type f -atime +7 -delete
    find /var/tmp -type f -atime +7 -delete
    log "Temporary files cleanup completed."

    # Step 4: Remove old generations of the system profile
    log "Removing old system generations..."
    nix-env --delete-generations old
    if [ $? -eq 0 ]; then
      log "Old system generations removed successfully."
    else
      log "Failed to remove old system generations. Please check for errors."
      exit 1
    fi

    # Step 5: Clean up the Nix user profile (if applicable)
    log "Cleaning up user profile generations..."
    nix-env --delete-generations old --profile /nix/var/nix/profiles/per-user/$USER/profile
    if [ $? -eq 0 ]; then
      log "User profile generations cleaned up successfully."
    else
      log "Failed to clean up user profile generations. Please check for errors."
      exit 1
    fi

    # Step 6: Clean up flake-related caches (optional)
    log "Cleaning up flake caches..."
    rm -rf ~/.cache/nix/eval-cache-v*
    rm -rf ~/.cache/nix/flake-registry.json
    log "Flake caches cleaned up."

    # Step 7: Clean up Nix build logs (optional)
    log "Cleaning up Nix build logs..."
    rm -rf /nix/var/log/nix/drvs/*
    log "Nix build logs cleaned up."

    # Step 8: Final report
    log "NixOS cleanup completed successfully!"
  '';
}
