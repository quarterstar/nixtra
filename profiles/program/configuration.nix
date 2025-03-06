{ inputs, ... }:

{
  imports = [
    # Modules
    ../../modules/system/pkgs/cli/git.nix
    ../../modules/system/pkgs/cli/network.nix
    ../../modules/system/pkgs/cli/stats.nix
    ../../modules/system/pkgs/cli/sysadmin.nix
    ../../modules/system/pkgs/cli/git.nix
    ../../modules/system/pkgs/signing/gnupg.nix
    ../../modules/system/pkgs/file/gparted.nix
    ../../modules/system/shell/aliases.nix

    # Services
    ../../modules/system/services/ollama.nix
  ];
}
