{ profile, pkgs, createCommand, ... }:

{
  imports = [
    ../../userspace/services/reload-waybar.nix
    ../../userspace/services/rainbow-border.nix
    ../../userspace/services/switch-wallpaper.nix
  ];

  # Enable compositor
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  programs.waybar.enable = true;
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    hyprland # Compositor
    waybar # Wayland bar
    dunst # Notif manager
    swww # Wallpaper daemon
    rofi-wayland # App launcher
    plymouth # Display manager dependency
    gsettings-desktop-schemas # GSettings Schemas (directory popups)
    adwaita-icon-theme
    gtk3
    tzdata

    # Dependencies by cava module in waybar
    iniparser
    fftw
    helvum

    vlc # Startup sound effect

    # Set random wallpaper after login (may take a long time for gifs)
    (callPackage ../../drvs/wayland-random-wallpaper/default.nix {})
  ];

  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";

    # Make Git not try to open an authorization window for pushing
    # and other operations, fixes a crash for Hyprland.
    GIT_ASKPASS = "/bin/stub";

    # https://stackoverflow.com/a/71402854
    QT_QPA_PLATFORM = "wayland";
  };
}
