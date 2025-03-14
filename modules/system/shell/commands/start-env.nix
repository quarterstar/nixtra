{ pkgs, profile, createCommand, ... }:

if profile.display.type == "hyprland" then createCommand {
    inherit pkgs;
    inherit profile;
    name = "start-env";
    buildInputs = with pkgs; [ keepassxc ];

    # Waybar is started with reload-waybar userspace service
    command = ''
      ${profile.user.terminal}
      ${profile.user.browser}
      ${pkgs.keepassxc}/bin/keepassxc
      ${pkgs.swww}/bin/swww init
      random-wallpaper
    '';
} else createCommand {
    inherit pkgs;
    inherit profile;
    name = "start-env";
    buildInputs = [ ];

    command = ''
      echo "unsupported env"
    '';
}
