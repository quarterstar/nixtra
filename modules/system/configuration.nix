{ settings, profile, timestamp, lib, pkgs, unstable-pkgs, inputs, ... }:

let
  # Note for beginners:
  # 'pkgs' here would be the result of importing the nixpkgs
  # expression, typically with a specific system and overlays applied.
  # e.g., pkgs = import <nixpkgs> { system = "x86_64-linux"; };

  currentTimestamp = lib.readFile
    "${pkgs.runCommand "timestamp" { } "date +%Y-%m-%d_%H-%M-%S > $out"}";
in {
  # Basic
  imports = [
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
    (./fs + ("/" + settings.system.filesystem) + ".nix")
    ./peripherals/peripherals.nix

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
    ./services/microsocks.nix
    ./services/i2p.nix

    # Virtualization
    ./services/virt.nix

    # Configuration
    ./config/global/prelude.nix
    (./config + ("/" + profile.user.config) + "/prelude.nix")

    ./extra/extra.nix
  ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable NUR
  # NUR for unstable channel(s) is considered a security risk in Nixtra, so it remains disabled.
  nixpkgs.config.packageOverrides = pkgs:
    if settings.system.nur then {
      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
    } else
      { };

  # Save configurations from old generations
  # Not currently supported by Flakes
  #system.copySystemConfiguration = true;

  # "Unsafe" packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) profile.security.permittedUnfreePackages;
  nixpkgs.config.permittedInsecurePackages =
    if !profile.security.networking then
      profile.security.permittedInsecurePackages
    else
      [ ];

  # Use automatic garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  # Enable docker containers support
  virtualisation.docker.enable = lib.mkIf profile.security.virtualization true;
  virtualisation.libvirtd.enable =
    lib.mkIf profile.security.virtualization true;

  # Define default shell for all users globally
  users.defaultUserShell = pkgs.${profile.user.shell};

  # Enable networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = lib.mkIf profile.security.networking true;
  networking.networkmanager.ethernet.macAddress = "random";

  # Enable debug symbols for NixOS packages
  # to make them easier to troubleshoot
  environment.enableDebugInfo = true;

  # Set system's name
  networking.hostName = if settings.system.hostnameProfilePrefix then
    "${settings.system.hostname}-${settings.config.profile}"
  else
    settings.system.hostname;

  # Set timezone
  time.timeZone =
    if !settings.system.timezone.auto then settings.system.timezone else null;
  services.automatic-timezoned.enable = settings.system.timezone.auto;

  # Select internationalisation properties.
  i18n.defaultLocale = settings.system.locale;

  # Make users immutable
  #users.mutableUsers = false;

  # TOD
  programs.dconf.enable = true;

  # Ensure the system has common libraries for proprietary software, if needed.
  programs.nix-ld.enable = profile.security.unpatchedBinaries;

  environment.systemPackages = with pkgs; [
    nixfmt-classic # Nix formatter
    nixd # Nix language server
  ];

  programs.appimage = if profile.security.appimage then {
    enable = true;
    binfmt = true; # Enable binary format support
  } else
    { };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };

  # Configure home manager
  home-manager = {
    extraSpecialArgs = {
      inherit settings;
      inherit profile;
      inherit inputs;
      inherit unstable-pkgs;
    };
    useGlobalPkgs = true;
    users = {
      "user" = import ../userspace/base/user.nix;
      "root" = import ../userspace/base/root.nix;
    } // (builtins.listToAttrs (map (username: {
      name = username;
      value = import ../userspace/base/custom-user.nix {
        inherit username;
        inherit settings;
      };
    }) settings.security.extraUsers));
  };

  # Automatically fix collisions
  home-manager.backupFileExtension = "hm.backup.${currentTimestamp}";

  # Define a user account.
  users.users = {
    ${profile.user.username} = {
      isNormalUser = true;
      extraGroups = profile.user.groups;
    };
  } // (builtins.listToAttrs (map (username: {
    name = username;
    value = { isNormalUser = true; };
  }) settings.security.extraUsers));

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion =
    settings.system.initialVersion; # Did you read the comment?
}
