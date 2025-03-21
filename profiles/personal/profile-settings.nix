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
    config = "quarterstar"; # Available options: quarterstar, empty (use `empty` if you want to cherrypick individual configs in home.nix)
    shell = "zsh"; # Available options: zsh (recommended), fish, bash
    browser = "tor-browser"; # The preferred browser for applications to use
    terminal = "kitty"; # The preferred terminal for applications to use
    editor = "lvim"; # The preferred editor for applications to use
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

  env = {
    wallpaper = {
      # Preferred wallpaper - if not set, will use a random one.
      preference = "";

      useLiveWallpapers = true; # Whether to use animated wallpapers (can impact performance)

      # Minutes after which wallpaper should be switched.
      switchInterval = 45;
    };

    # Window Manager configuration
    wm = {
      # Bottom bar with applications
      taskbar = {
        enable = true;

        # Programs to add to your bottom taskbar
        # Icons are stored in $REPO/assets/icons
        # Icons are copied into $HOME/.config/waybar/icons
        apps = [
          { program = "kitty"; icon = "terminal.png"; workspace = 1; }
          { program = "librewolf"; icon = "librewolf.png"; workspace = 2; }
          { program = "tor-browser-clearnet"; icon = "tor-browser-clearnet.png"; workspace = 2; }
          { program = "tor-browser-proxy"; icon = "tor-browser-proxy.png"; workspace = 3; }
          { program = "tor-browser"; icon = "tor-browser.png"; workspace = 3; }
          { program = "thunar"; icon = "file-manager.png"; workspace = 5; }
          { program = "virt-manager"; icon = "vm.png"; workspace = 5; }
          { program = "krita"; icon = "krita.png"; workspace = 5; }
          { program = "keepassxc"; icon = "keepassxc.png"; workspace = 10; }
        ];

        # Size of icons to be used in bottom taskbar
        # e.g. 50 = 50x50
        iconSize = 38;
      };
    };

    # Desktop Environment configuration
    de = {
      # TODO
    };
    
    programs = [
      { program = "ssh"; envVars = { TERM = "xterm-256color"; }; }
      { program = "lxappearance"; envVars = { GDK_BACKEND = "x11"; }; }
    ];
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
        "freetube"
      ];
    };

    replaceCoreutilsWithUutils = true;

    # All permitted insecure packages may only be used under a profile whose `networking` is disabled.
    # If `networking` is enabled, their installation will not be permitted.
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

  git = {
    useTorProxy = true;

    # Add repositories you would like cloned into
    # your user account at ~/Repositories
    repositories = [
      { service = "github"; owner = "quarterstar"; repository = "opsec-index"; }
      { service = "github"; owner = "quarterstar"; repository = "opsec-infra"; }
    ];
  };

  tor = {
    enable = true;

    aliases = {
      enable = true;

      # List of programs to run over Tor (requires torsocks)
      programs = [
        # Native Tor SOCKS5 proxy supported for Git, so no need for torsocks
        # Refer to `git.useTorProxy`
        #"git"

        "freetube"
      ];
    };

    publicProxy = {
      address = "43.157.34.94";
      port = 1777;
    };
  };

  shell = {
    enable = true;

    # Alternative ways to reference programs in shell
    aliases = pkgs: {
      rm = "${pkgs.trash-cli}/bin/trash";
      neofetch = "${pkgs.fastfetch}/bin/fastfetch";
      ls = "${pkgs.eza}/bin/eza";
    };

    # Show information similar to neofetch on startup
    fastfetchOnStartup = true;

    commands = {
      # Whether to enable special Nixtra commands e.g. `nixtra-screenshot` (recommended)
      enable = true;

      # The prefix to use for Nixtra commands.
      # For example, to change `nixtra-screenshot` command to `nixos-screenshot`,
      # change this to `nixos`.
      # WARNING: changing this may break raw configs that expect it to be the default.
      # It is advised that you do not modify it.
      prefix = "nixtra";
    };
  };
}
