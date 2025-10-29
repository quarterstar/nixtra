{
  description = "Nixtra Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {                                                                                                          
      url = "github:hercules-ci/flake-parts";                                                                                
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";                                                                            
    };

    #nur = {
    #  url = "github:nix-community/nur";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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

    # zeek-nix = {
    #   url = "github:hardenedlinux/zeek-nix/main";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, flake-parts
    , home-manager, sops-nix, lanzaboote, disko, nixos-generators, ...
    }:
    let
      hostSettings = import ./settings.nix;
      hostProfileSettings =
        import (./profiles + ("/" + hostSettings.profile) + "/settings.nix");
      hostName = if hostProfileSettings.useHostnameProfilePrefix then
        "${hostProfileSettings.hostname}-${hostSettings.profile}"
      else
        hostProfileSettings.hostname;

      otherProfiles = builtins.filter (profile: profile != hostSettings.profile) (builtins.attrNames (builtins.readDir ./profiles));
      
      mkNixtraSystem = profile: 
        let
          profileSettings =
            import (./profiles + ("/" + profile) + "/settings.nix");
          unstableNixpkgsConfig =
            import ./modules/system/unstable-configuration.nix;
        in nixpkgs.lib.nixosSystem {
            system = profileSettings.arch;
            modules = [
              ./modules/system/configuration.nix
              home-manager.nixosModules.default
              sops-nix.nixosModules.sops
              lanzaboote.nixosModules.lanzaboote
              disko.nixosModules.disko
              #impermanence.nixosModules.impermanence
            ];
            specialArgs = {
              settings = {
                inherit profile;
              };
              inherit profileSettings;
              inherit inputs;
              unstable-pkgs =
                nixpkgs-unstable.legacyPackages.${profileSettings.arch};
            };
          };
    in flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];

      systems = [ ];

      # perSystem = { config, pkgs, system, ... }:
      #   let
          # pkgsWithZeek = import inputs.nixpkgs {
          #   inherit system;
          #   overlays =
          #     (inputs.zeek-nix.overlays or [ inputs.zeek-nix.overlay ]);
          # };
        # in {
        #   packages = {
            #zeek = inputs.zeek-nix.packages.${system}.zeek-latest;

            # optional: expose helper that builds zeek with plugins using zeek-nix's lib
            # zeek-with-plugins = inputs.zeek-nix.lib.zeekWithPlugins {
            #   package = inputs.zeek-nix.packages.${system}.zeek-latest;
            #   plugins = [
            #     # example: inputs.zeek-nix.lib.nixpkgs.zeek-sources.<plugin>
            #   ];
            # };
          # };
        # };

      flake.nixosModules = { };

      flake.nixosConfigurations = {
        ${hostName} = mkNixtraSystem hostSettings.profile;

        # nix build .#nixosConfigurations.iso.config.system.build.images.iso
        iso = nixpkgs.lib.nixosSystem {
          system = hostProfileSettings.arch;
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
              imports = [
                (modulesPath + "/installer/cd‑dvd/installation‑cd‑minimal.nix")
              ];
              environment.systemPackages = [ pkgs.neovim ];
            })
          ];
          specialArgs = { inherit inputs; };
        };
      } // builtins.listToAttrs (map (profile:
          { name  = "profile-${profile}";
            value = mkNixtraSystem profile;
          }
        ) otherProfiles);
    };

  nixConfig = {
    accept-flake-config = true;
    warn-dirty = false;
  };
}
