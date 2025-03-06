# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ settings, profile, config, lib, pkgs, inputs, ... }:

{
  # Basic
  imports =
    [
      inputs.home-manager.nixosModules.default

      # Profile-based configuration
      (../../profiles + ("/" + settings.config.profile) + "/configuration.nix")

      # Parts
      (./gpu + ("/" + settings.hardware.gpu) + ".nix")
      (./audio + ("/" + profile.audio.backend) + ".nix")
      (./server + ("/" + profile.display.server) + ".nix")
      (./wm + ("/" + profile.display.type) + ".nix")
      (./theme + ("/" + profile.display.theme) + ".nix")

      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Security
      ./security/doas.nix
      ./security/firewall.nix
      ./security/audit.nix
      ./security/firejail.nix
      ./security/close-on-suspend.nix

      # Networks
      ./networks/tornet.nix

      # Settings-based imports
      ./fs/windows.nix
      ./patches/udev.nix

      # Services
      #./services/tor.nix

      # Shell
      ./shell/commands.nix

      # Overlay
      ../overlays.nix

      # Other
      ./fonts.nix
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Save configurations from old generations
  # system.copySystemConfiguration = true;

  # "Unsafe" packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) profile.security.permittedUnfreePackages;
  #nixpkgs.config.permittedInsecurePackages = lib.mkIf (!profile.security.networking) profile.security.permittedInsecurePackages;
  nixpkgs.config.permittedInsecurePackages = profile.security.permittedInsecurePackages;

  # Enable docker containers support
  virtualisation.docker.enable = lib.mkIf profile.security.virtualization true;
  virtualisation.libvirtd.enable = lib.mkIf profile.security.virtualization true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = lib.mkIf profile.security.networking true;

  networking.hostName = if settings.system.hostnameProfilePrefix
    then "${settings.system.hostname}-${settings.config.profile}"
    else settings.system.hostname;

  # Set timezone
  time.timeZone = settings.system.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = settings.system.locale;

  # Make users immutable
  #users.mutableUsers = false;

  # Choose default editor
  environment.variables = {
    EDITOR = profile.user.editor;
    TERMINAL = profile.user.terminal;
    VISUAL = profile.user.editor;
  };

  # Configure home manager
  home-manager = {
    extraSpecialArgs = {
      inherit settings;
      inherit profile;
      inherit inputs;
    };
    useGlobalPkgs = true;
    users = {
      "user" = import ../../profiles/${settings.config.profile}/home.nix;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${profile.user.username} = {
    isNormalUser = true;
    extraGroups = profile.user.groups;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = settings.system.initialVersion; # Did you read the comment?
}
