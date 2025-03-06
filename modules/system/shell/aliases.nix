{ config, pkgs, home, ... }:

{
  imports = [
    ../pkgs/cli/security.nix
  ];

  environment.shellAliases = {
    my-nix-clean = "nix-store --gc && nix-env --delete-generations old";
    my-nix-rebuild = "nixos-rebuild switch --flake /etc/nixos/#default";
    my-nix-clean-cache = "sync; echo 3 > /proc/sys/vm/drop_caches";
    docker-full-clean = "docker rm $(docker ps -a -q) && docker rmi $(docker images -q) && docker system prune && docker system prune -af";
    rm = "trash";
  };
}
