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
    username = "user"; # Username of the main user.
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
        apps = pkgs: [
          { program = "${pkgs.kitty}/bin/kitty"; icon = "terminal.png"; }
          { program = "${pkgs.xfce.thunar}/bin/thunar"; icon = "file-manager.png"; }
          { program = "${pkgs.lunarvim}/bin/lunarvim"; icon = "lunarvim.png"; }
          { program = "${pkgs.librewolf}/bin/librewolf"; icon = "librewolf.png"; }
          { program = "${pkgs.freetube}/bin/freetube"; icon = "freetube.png"; }
          { program = "tor-browser-clearnet"; icon = "tor-browser-clearnet.png"; }
          { program = "tor-browser-proxy"; icon = "tor-browser-proxy.png"; }
          { program = "tor-browser"; icon = "tor-browser.png"; }
          { program = "${pkgs.okular}/bin/okular"; icon = "okular.png"; }
          { program = "${pkgs.virt-manager}/bin/virt-manager"; icon = "vm.png"; }
          { program = "${pkgs.openboard}/bin/OpenBoard"; icon = "openboard.png"; }
          { program = "${pkgs.krita}/bin/krita"; icon = "krita.png"; }
          { program = "${pkgs.keepassxc}/bin/keepassxc"; icon = "keepassxc.png"; }
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

    # Packet filtering and forwarding
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
      ];
      allowedUDPPorts = [ ];
    };

    virtualization = true; # Virtual machines
    scanning = true; # Intrusion Detection System with Sirucata
    aliases = true; # Aliases for commands such as `rm` to prevent accidental data loss

    # Sandboxing for userspace applications without the use of virtual machines or Docker.
    # Refer to `03-hardening.md` in docs for more information.
    firejail = true;

    # Applications which clipboard listeners (for clipboard history) like cliphist should
    # not listen to, e.g. password managers
    excludedClipboardPrograms = [
      "x-kde-passwordManagerHint"
    ];

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
    signCommits = true;
    useTorProxy = true;
    randomizeCommitDate = true;

    autoPush = {
      enable = true;
      time = "00:00";
      repositories = [
        # Automatically push to all repositories
        { service = "*"; owner = "*"; repository = "*"; }
      ];
    };

    autoClone = {
      enable = true;

      repositories = [
        { service = "github"; owner = "quarterstar"; repository = "opsec-index"; }
        { service = "github"; owner = "quarterstar"; repository = "opsec-infra"; }
      ];
    };
  };

  tor = {
    enable = true;

    # Whether to listen to ports for hidden service
    # if running a monero node locally
    isRunMoneroNode = true;

    aliases = {
      enable = true;

      # List of programs to run over Tor (requires torsocks)
      programs = pkgs: [
        # Native Tor SOCKS5 proxy supported for Git, so no need for torsocks
        # Refer to `git.useTorProxy`
        #{ name = "git"; hardAlias = true; systemWideInstall = true; }

        #{ program = "${pkgs.freetube}/bin/freetube"; }
        { program = "com.cakewallet.CakeWallet"; }
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
      rm = "${pkgs.trash-cli}/bin/trash"; # Remove files and put them to trash
      neofetch = "${pkgs.fastfetch}/bin/fastfetch"; # Neofetch alternative written in C
      ls = "${pkgs.eza}/bin/eza"; # Modern alternative to ls command
      clear = "${pkgs.ncurses}/bin/clear && printf '\033[3J'"; # Clear screen and scrollback buffer in WMs
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

  flatpak = {
    enable = true;

    sources = [
      { name = "flathub"; source = "https://dl.flathub.org/repo/flathub.flatpakrepo"; allowForUser = true; }
    ];

    apps = [
      { app = "com.cakewallet.CakeWallet"; url = "https://github.com/cake-tech/cake_wallet/releases/download/v4.24.0/Cake_Wallet_v4.24.0_Linux.flatpak"; }
    ];
  };
}
