{
  description = "Nixtra Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-flake = {
      url = "github:cpu/rust-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Advanced NixOS security hardening
    nix-mineral = {
      url = "github:cynicsketch/nix-mineral";
      flake = false;
    };

    # Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #impermanence.url = "github:nix-community/impermanence";

    # For creating ISOs with fine-grained control
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    betterfox = {
      url = "github:heitoraugustoln/betterfox-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, nur, nixpkgs-unstable, flake-parts, home-manager, rust-flake, sops-nix, lanzaboote, disko, nixos-generators, betterfox, ... }:
    let
      settings = import ./settings.nix;
      unstableNixpkgsConfig = import ./modules/system/unstable-configuration.nix;
      hostname =
        if settings.system.hostnameProfilePrefix then
          "${settings.system.hostname}-${settings.config.profile}"
        else
          settings.system.hostname;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
      ];

      systems = [ ];

      perSystem = { config, pkgs, system, ... }: {
      };

      flake.nixosModules = {
        #myFormats = { config, modulePath, ... }: {
        #};
      };

      flake.nixosConfigurations = {
        ${hostname} = nixpkgs.lib.nixosSystem {
          system = settings.system.arch;
          modules = [
            ./modules/system/configuration.nix
            home-manager.nixosModules.default
            sops-nix.nixosModules.sops
            lanzaboote.nixosModules.lanzaboote
            disko.nixosModules.disko
            #impermanence.nixosModules.impermanence
          ];
          specialArgs = {
            inherit settings;
            inherit inputs;
            unstable-pkgs = nixpkgs-unstable.legacyPackages.${settings.system.arch};
            #unstable-pkgs = import nixpkgs-unstable {
            #  system = settings.system.arch;
            #  config = unstableNixpkgsConfig {
            #    lib = inputs.nixpkgs-unstable.lib;
            #  };
            #};
          };
        };
        # nix build .#nixosConfigurations.iso.config.system.build.images.iso
        iso = nixpkgs.lib.nixosSystem {
          system = settings.system.arch;
          modules = [
            #(nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
            ({ pkgs, modulesPath, ... }: {
              imports = [
                (modulesPath + "/installer/cd‑dvd/installation‑cd‑minimal.nix")
              ];
              environment.systemPackages = [ pkgs.neovim ];
            })
          ];
        };
        specialIso = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          # "formats" refer to different types of output images such as ISOs, VM disk images, raw disk images, and more that NixOS can produce from a single configuration.
          format = "install-iso";
          modules = [
            #"${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            #./iso.nix
            ({ pkgs, modulesPath, ... }: {
              imports = [ (modulesPath + "/installer/cd‑dvd/installation‑cd‑minimal.nix") ];
              environment.systemPackages = [ pkgs.neovim ];
            })
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };

  nixConfig = {
    accept-flake-config = true;
    warn-dirty = false;
  };
}
