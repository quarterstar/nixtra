{ pkgs, ... }:

{
  imports = [
    ../../userspace/services/reload-waybar.nix
    ../../userspace/services/rainbow-border.nix
    ../../userspace/services/switch-wallpaper.nix
    ../../userspace/services/delete-cliphist.nix
  ];

  # Enable compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
    systemd.setPath.enable = true;
  };
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    hyprland # Compositor
    hyprland-qtutils # Dependency for some Hyprland dialogs
    waybar # Wayland bar
    mako # Notif manager
    swww # Wallpaper daemon
    rofi-wayland # App launcher
    plymouth # Display manager dependency
    gsettings-desktop-schemas # GSettings Schemas (directory popups)
    adwaita-icon-theme
    gtk3
    tzdata
    hyprpicker

    # Dependencies by cava module in waybar
    iniparser
    fftw
    helvum
    libnotify

    vlc # Startup sound effect
  ];

  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";

    # Make Git not try to open an authorization window for pushing
    # and other operations, fixes a crash for Hyprland.
    GIT_ASKPASS = "/bin/stub";

    # https://stackoverflow.com/a/71402854
    QT_QPA_PLATFORM = "wayland";

    # https://askubuntu.com/a/1044432
    #QT_QPA_PLATFORMTHEME = "gtk3";
  };

  # Create a named pipe (FIFO) at boot time
  systemd.services.create-hypr-pipe = {
    description = "Create named pipe for Hyprland";
    wantedBy = [ "multi-user.target" ];

    # The script that will create the FIFO pipe
    script = ''
      #!/bin/sh
      rm -f /tmp/hypr_start_pipe
      mkfifo /tmp/hypr_start_pipe
      chmod 666 /tmp/hypr_start_pipe
    '';

    # Make sure it's a one-shot service
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
  };
}
