{ settings, profile, timestamp, config, lib, pkgs, inputs, ... }:

let
  currentTimestamp = lib.readFile "${pkgs.runCommand "timestamp" { env.when = timestamp; } "echo -n `date -d @$when +%Y-%m-%d_%H-%M-%S` > $out"}";
in {
  # Basic
  imports =
    [
      inputs.home-manager.nixosModules.default

      # Overlays
      ../overlays/overlays.nix
      ../overrides/overrides.nix

      # Profile-based configuration
      (../../profiles + ("/" + settings.config.profile) + "/configuration.nix")

      # Parts
      (./gpu + ("/" + settings.hardware.gpu) + ".nix")
      (./audio + ("/" + profile.audio.backend) + ".nix")
      (./server + ("/" + profile.display.server) + ".nix")
      (./wm + ("/" + profile.display.type) + ".nix")
      (./theme + ("/" + profile.display.theme) + ".nix")
      (./shell/backend + ("/" + profile.user.shell) + ".nix")

      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Security
      ./security/security.nix

      # Networks
      ./networks/tornet.nix

      # Settings-based imports
      ./fs/swap.nix
      ./patches/udev.nix

      # Shell
      ./shell/commands/commands.nix
      ./shell/aliases.nix

      # Other
      ./fonts.nix

      # Proxy
      ./services/tor.nix
      ./services/i2p.nix

      # Configuration
      ./config/global/prelude.nix
      (./config + ("/" + profile.user.config) + "/prelude.nix")

      ./extra.nix
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable NUR
  nixpkgs.config.packageOverrides = pkgs: if settings.system.nur then {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  } else {};

  # Save configurations from old generations
  # Not currently supported by Flakes
  #system.copySystemConfiguration = true;

  # "Unsafe" packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) profile.security.permittedUnfreePackages;
  nixpkgs.config.permittedInsecurePackages = if !profile.security.networking then profile.security.permittedInsecurePackages else [];

  # Use automatic garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  # Enable docker containers support
  virtualisation.docker.enable = lib.mkIf profile.security.virtualization true;
  virtualisation.libvirtd.enable = lib.mkIf profile.security.virtualization true;

  # Define default shell for all users globally
  users.defaultUserShell = pkgs.${profile.user.shell};

  # Enable networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = lib.mkIf profile.security.networking true;
  networking.networkmanager.ethernet.macAddress = "random";

  # Set system's name
  networking.hostName = if settings.system.hostnameProfilePrefix
    then "${settings.system.hostname}-${settings.config.profile}"
    else settings.system.hostname;

  # Set timezone
  time.timeZone = settings.system.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = settings.system.locale;

  # Make users immutable
  #users.mutableUsers = false;

  # Configure home manager
  home-manager = {
    extraSpecialArgs = {
      inherit settings;
      inherit profile;
      inherit inputs;
    };
    useGlobalPkgs = true;
    users = {
      "user" = import ../userspace/base/user.nix;
      "root" = import ../userspace/base/root.nix;
    } // (builtins.listToAttrs
      (map (username:
        { name = username; value = import ../userspace/base/custom-user.nix { inherit username; inherit settings; }; }
      ) settings.security.extraUsers));
  };

  # Automatically fix collisions
  home-manager.backupFileExtension = "backup.${currentTimestamp}";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    ${profile.user.username} = {
      isNormalUser = true;
      extraGroups = profile.user.groups;
    };
  } // (builtins.listToAttrs (map (username: { name = username; value = { isNormalUser = true; }; }) settings.security.extraUsers));

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = settings.system.initialVersion; # Did you read the comment?
}
