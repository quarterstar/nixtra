{
  description = "Nixtra Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-flake.url = "github:cpu/rust-flake";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, flake-parts, rust-flake, ... }:
    let
      settings = import ./settings.nix;
      profile = import ./profiles/${settings.config.profile}/profile-settings.nix;
      unstableNixpkgsConfig = import ./modules/system/unstable-configuration.nix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
      ];

      systems = [ ];

      perSystem = { config, pkgs, system, ... }: {
      };

      flake.nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          system = settings.system.arch;
          modules = [
            ./modules/system/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
          specialArgs = {
            inherit settings;
            inherit profile;
            inherit inputs;
            unstable-pkgs = import inputs.nixpkgs-unstable {
              system = settings.system.arch;
              config = unstableNixpkgsConfig {
                lib = inputs.nixpkgs-unstable.lib;
                inherit profile;
              };
            };
            timestamp = self.lastModified;
          };
        };
      };
    };
}
