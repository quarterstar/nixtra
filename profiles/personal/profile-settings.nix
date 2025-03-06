########################################################
#                                                      #
# Nixtra Configuration                                 #
# Configuration for NixOS                              #
#                                                      #
# Repository: https://github.com/quarterstar/nixtra    #
# Documentation: https://github.com/quarterstar/nixtra #
#                                                      #
########################################################

{
  user = {
    username = "user"; # Warning: compilation and distribution of software from your host system without virtualization may lead to username leakage!
    terminal = "kitty"; # The kitty terminal is preferred for the Hyprland setup provided by Nixtra.
    editor = "lvim"; # Default: LunarVim
    groups = [
      "wheel" # sudo/doas
      "docker" # For using docker on userspace
      "libvirtd" # For managing VMs on userspace
    ];
  };

  # Display server & protocol
  display = {
    server = "wayland"; # Available options: wayland, none
    type = "hyprland"; # Available options: hyprland, none
    
    # Available options: nordic, none
    # If a theme is not provided out-of-the-box,
    # it may not look good with the pre-configured
    # window managers and/or desktop environments
    # provided by Nixtra.
    theme = "nordic"; # Dark theme

    # Available options: dark, light, ""
    themeType = "dark";
  };

  audio = {
    backend = "pipewire"; # Available options: pipewire, pulseaudio, none
  };

  security = {
    networking = true; # Any kind of networking capability for the system
    firewall = true; # Packet filtering and forwarding
    virtualization = true; # Virtual machines
    scanning = true; # Intrusion Detection System with Sirucata
    aliases = true; # Aliases for commands such as `rm` to prevent accidental data loss

    # Sandboxing for userspace applications without the use of virtual machines or Docker.
    # Refer to `03-hardening.md` in docs for more information.
    firejail = true;

    # Applications to close when suspending PC or putting it to sleep.
    closeOnSuspend = {
      enable = true;
      applications = [
        "firefox"
        "librewolf"
        "tor-browser"
      ];
    };

    # All permitted insecure packages may only be used under a profile with no networking enabled.
    permittedInsecurePackages = [
      # Python2 is required for some scripts, but you can use `2to3` script to automatically migrate to Python3.
      # "python-2.7.18.8"
    ];

    # Permitted unfree packages must explicitly be set to ensure the acknowledgement of the user.
    permittedUnfreePackages = [
      # Example unfree packages:
      # "drawio" # Unfree since 24.11; 24.05 contains old build
      # "charles"
      # "geogebra"
      # "ida-free"
      # "steam"
      # "steam-original"
      # "steam-run"
      # "aseprite"
      # "rust-rover"
      # "clion"
    ];
  };

  networks = {
    # Onion network subnet
    # It is not recommended that you run all
    # your traffic through Tor.
    tornet = {
      enable = false;
      subnet = "192.168.2.0/24";
    };
  };

  browser = {
    # Close browser after waking up when suspending the
    # system for security reasons and preventing data
    # leakage.
    closeOnSuspend = true;
  };

  services = {
    # Run Tor node.
    tor = {
      #enable = true;
    };
  };

  shell = {
    enable = true;

    # Show information similar to neofetch on startup
    fastfetchOnStartup = true;

    commands = {
      # Whether to enable special Nixtra commands e.g. `nixtra-screenshot` (recommended)
      enable = true;

      # The prefix to use for Nixtra commands.
      # For example, to change `nixtra-screenshot` command to `nixos-screenshot`,
      # change this to `nixos`.
      prefix = "nixtra";
    };
  };
}
