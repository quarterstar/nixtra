{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    settings = import ./settings.nix;
    profile = import ./profiles/${settings.config.profile}/profile-settings.nix;
  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        modules = [
          ./modules/system/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
        specialArgs = {
          inherit settings;
          inherit profile;
          inherit inputs;
          timestamp = self.lastModified;
        };
      };
    };
  };
}
