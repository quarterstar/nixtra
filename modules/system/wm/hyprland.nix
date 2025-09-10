{ nixtraLib, config, lib, pkgs, ... }:

{
  config = lib.mkIf
    (config.nixtra.display.enable && config.nixtra.display.type == "hyprland") {

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

        # Misc dependencies
        lm_sensors

        vlc # Startup sound effect
        gromit-mpx # Drawing

        # Hypr ecosystem
        hyprshade
        hyprsunset
        hyprlock

        # Wayland programs
        swayidle

        (nixtraLib.command.createCommand {
          name = "run-if-active";
          prefix = "hyprland";
          buildInputs = [ jq ];
          command = ''
            # Log output
            #LOGFILE="/tmp/my-hypr-script.log"
            #exec > >(tee -a "$LOGFILE") 2>&1

            ACTIVE_WORKSPACE=$(hyprctl activewindow -j | jq -r '.workspace.name')
            if [[ "$ACTIVE_WORKSPACE" == "$1" ]]; then
              eval "$2"
            else
              hyprctl dispatch sendshortcut CONTROL_L, Z, activewindow 
            fi
          '';
        })
      ];

      environment.sessionVariables = {
        HYPR_PLUGIN_DIR = pkgs.symlinkJoin {
          name = "hyprland-plugins";
          paths = with pkgs.hyprlandPlugins;
            [
              hyprspace
              #hyprexpo
            ];
        };

        # Hint electron apps to use Wayland
        NIXOS_OZONE_WL = "1";

        # Make Git not try to open an authorization window for pushing
        # and other operations, fixes a crash for Hyprland.
        GIT_ASKPASS = "/bin/stub";
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
    };
}
