{ pkgs, profile, createCommand, ... }:

if profile.display.type == "hyprland" then createCommand {
    inherit pkgs;
    inherit profile;
    name = "start-env";
    buildInputs = with pkgs; [ keepassxc ];

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
    buildInputs = with pkgs; [ ];

    command = ''
      echo "unsupported env"
    '';
}
