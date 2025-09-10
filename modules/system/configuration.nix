{ config, settings, timestamp, lib, pkgs, unstable-pkgs, inputs, nur, ... }:

let
  # Note for beginners:
  # 'pkgs' here would be the result of importing the nixpkgs
  # expression, typically with a specific system and overlays applied.
  # e.g., pkgs = import <nixpkgs> { system = "x86_64-linux"; };

  currentTimestamp = lib.readFile
    "${pkgs.runCommand "timestamp" { } "date +%Y-%m-%d_%H-%M-%S > $out"}";

  modulesPath = "${inputs.nixpkgs}/nixos/modules";

  nixtraLib = import ../lib/lib.nix { inherit config lib pkgs settings; };
in {
  imports = [
    inputs.home-manager.nixosModules.default

    # Overlays
    ../overrides/overrides.nix

    # Nixtra options and profile
    ../options.nix

    # Profile-based configuration
    (../../profiles + ("/" + settings.config.profile) + "/configuration.nix")

    # Parts
    # See the module evaluation section in docs/05-cheatsheet.md
    # to understand why conditional importing is used here.
    (./cpu + ("/" + settings.hardware.cpu) + ".nix")
    (./gpu + ("/" + settings.hardware.gpu) + ".nix")
    ./audio/pipewire.nix
    ./audio/pulseaudio.nix
    ./server/wayland.nix
    #./server/x11.nix
    ./wm/hyprland.nix
    ./theme/nordic.nix
    ./shell/backend/zsh.nix
    ./shell/backend/common.nix
    (./fs + ("/" + settings.system.filesystem) + ".nix")

    # Desktop configurations
    (nixtraLib.loader.conditionalImport (config.nixtra.display.enable
      && config.nixtra.user.desktop.type == "flagship-hyprland")
      (./desktop/flagship-hyprland/prelude.nix))
    ./desktop/flagship-hyprland/options.nix

    ./peripherals/peripherals.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Security
    ./security/security.nix
    # FIXME: https://github.com/NixOS/nixpkgs/issues/360616
    #"${modulesPath}/profiles/hardened.nix" # NixOS security hardening
    "${inputs.nix-mineral}/nix-mineral.nix" # Complementary defaults for hardening for ones missed by security.nix and hardened.nix

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

    # Scheduling
    ./services/tasks.nix

    # Virtualization
    ./services/virt.nix

    ./extra/extra.nix
  ];

  config = {
    _module.args = { inherit nixtraLib; };

    # Set the options provided by the user's profile
    #inherit nixtra;
    nixtra =
      import ../../profiles/${settings.config.profile}/profile-settings.nix {
        inherit pkgs config;
      };

    nix = {
      settings = {
        # Enable Flakes
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true; # May make rebuilds longer but less size
        substituters = config.nixtra.nix.caches;
        trusted-public-keys = config.nixtra.nix.cachesKeys;
        #use-xdg-base-directories = true;
        warn-dirty = false;
        keep-outputs = true;
        keep-derivations = true;
      };
      optimise.automatic = true;
      package = pkgs.nixVersions.latest;
    };

    # Enable NUR
    # NUR for unstable channel(s) is considered a security risk in Nixtra, so it remains disabled.
    nixpkgs.overlays =
      if settings.system.nur then [ inputs.nur.overlays.default ] else [ ];
    #nixpkgs.config.packageOverrides = pkgs:
    #  if settings.system.nur then {
    #    nur = import (builtins.fetchTarball
    #      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    #        inherit pkgs;
    #      };
    #  } else
    #    { };

    # Save configurations from old generations
    # Not currently supported by Flakes
    #system.copySystemConfiguration = true;

    # "Unsafe" packages
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg)
      config.nixtra.security.permittedUnfreePackages;
    nixpkgs.config.permittedInsecurePackages =
      if !config.nixtra.security.networking then
        config.nixtra.security.permittedInsecurePackages
      else
        [ ];

    # Enable docker containers support
    virtualisation.docker.enable =
      lib.mkIf config.nixtra.security.virtualization true;
    virtualisation.libvirtd.enable =
      lib.mkIf config.nixtra.security.virtualization true;

    # Define default shell for all users globally
    users.defaultUserShell = pkgs.${config.nixtra.user.shell};

    # Enable networking
    networking.wireless.enable = false;
    networking.networkmanager.enable =
      lib.mkIf config.nixtra.security.networking true;
    networking.networkmanager.ethernet.macAddress =
      lib.mkIf config.nixtra.anonymity.spoofMacAddress "random";

    # Spoof network host ID
    # MAY cause issues with ZFS
    # Causes issue with geoclue and other services
    networking.hostId =
      lib.mkIf config.nixtra.anonymity.spoofMiscIdentifiers "00000000";

    # The DNS servers to use
    networking.nameservers =
      lib.mkIf (!config.nixtra.security.vpn.enable) config.nixtra.network.dns;
    services.resolved.fallbackDns =
      lib.mkIf (!config.nixtra.security.vpn.enable) config.nixtra.network.dns;

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

    # Make users immutable (declarative)
    users.mutableUsers = !config.nixtra.user.declarativeUsers.enable;

    # TOD
    programs.dconf.enable = true;

    # Ensure the system has common libraries for proprietary software, if needed.
    programs.nix-ld.enable = config.nixtra.security.unpatchedBinaries;

    environment.systemPackages = with pkgs; [
      nixfmt-classic # Nix formatter
      nixd # Nix language server
    ];

    programs.appimage = if config.nixtra.security.appimage then {
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
        inherit nixtraLib;
        inherit settings;
        inherit inputs;
        inherit unstable-pkgs;
      };
      useGlobalPkgs = true;
      users = {
        "user" = import ../userspace/base/user.nix;
        "root" = import ../userspace/base/root.nix;
      }; # // (builtins.listToAttrs (map (username: {
      #  name = username;
      #  value = import ../userspace/base/custom-user.nix {
      #    inherit username;
      #    inherit settings;
      #  };
      #}) settings.security.extraUsers));

      # Automatically fix collisions
      backupFileExtension = "hm.backup.${currentTimestamp}";

      sharedModules = [
        (import ../options.nix)
        (import ./desktop/flagship-hyprland/options.nix)
        #{ config = { nixtra = config.nixtra; }; }
      ];
    };

    # Define a user account.
    users.users = {
      ${config.nixtra.user.username} = {
        inherit (config.nixtra.user.uid)
        ;
        isNormalUser = true;
        extraGroups = config.nixtra.user.groups;
        linger = true;

        hashedPasswordFile = lib.mkIf config.nixtra.user.declarativeUsers.enable
          config.sops.secrets."${config.nixtra.user.declarativeUsers.passwordSecret}".path;
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
  };
}
