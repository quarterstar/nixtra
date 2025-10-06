{ lib, nixtraLib, ... }:

let
  inherit (nixtraLib.option) mkNixtraOption;

  idleKillerConcurrentAppSubmodule = lib.types.submodule {
    options = {
      class = lib.mkOption {
        type = lib.types.str;
        description = "The class name of the application";
      };
      timeout = lib.mkOption {
        type = lib.types.int;
        description =
          "The time (in seconds) that the app needs to be inactive for to be stopped";
      };
    };
  };
in {
  options.nixtra.desktop."flagship-hyprland" = {
    background = {
      enable = nixtraLib.option.mkNixtraOption lib.types.bool false
        "Whether to enable an animated background program.";
      program = nixtraLib.option.mkNixtraOption lib.types.str "amdgpu_top" ''
        The program to use as an animated background.
        This should be set to the class of the desired program.
        Get the class of a program in Hyprland with `hyprctl active-window`.
      '';
    };

    rainbowBorder = nixtraLib.option.mkNixtraOption lib.types.bool true
      "Whether to enable a rainbow window border.";
    rainbowShadow = nixtraLib.option.mkNixtraOption lib.types.bool true
      "Whether to enable rainbow window shadows.";

    workspaces = {
      names = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "Terminal"
          "Clearnet Browser"
          "Video Player"
          "Anonymous Browser"
          "Code Editor"
          "Virtual Machine"
          "Communication"
          "Gaming"
          "Document Viewer"
          "Drawing & Presentation"
          "Password Manager"
        ];
      };
      programs = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf lib.types.str);
        default = {
          "Terminal" = [ "kitty" "alacritty" ];
          "Clearnet Browser" = [ "firefox" "librewolf" "chrome" ];
          "Video Player" = [ "FreeTube" "vlc" "mpv" "com.stremio.stremio" ];
          "Anonymous Browser" = [ "Tor Browser" ];
          "Code Editor" = [ "lvim" "vim" "nvim" "codium" ];
          "Virtual Machine" = [ ".virt-manager-wrapped" ];
          "Communication" = [ "element-desktop" "discord" "so.libdb.dissent" ];
          "Gaming" = [
            "org.prismlauncher.PrismLauncher"
            "org.prismlauncher.EntryPoint"
            "org.prismlauncher-EntryPoint"
            "steam"
            "net.lutris.Lutris"
            "^(Minecraft.*)$"
          ];
          "Document Viewer" = [
            "Zettlr"
            "io.github.alainm23.planify"
            "libreoffice-startcenter"
            "org.kde.okular"
            "io.gitlab.news_flash.NewsFlash"
            "kiwix"
            "libreoffice-writer"
          ];
          "Drawing & Presentation" = [ "krita" "gimp" "org.oe-f." ];
          "Password Manager" = [ "org.keepassxc.KeePassXC" ];
        };
      };
    };

    idleKiller = {
      enable = mkNixtraOption lib.types.bool true
        "Whether to enable Idle Killer; check for inactive apps and stop them automatically";
      pollInterval = mkNixtraOption lib.types.int 5
        "How often (in seconds) to poll focused app and update timers";
      defaultTimeout = mkNixtraOption lib.types.int (30 * 60)
        "Default timeout (in seconds) for apps not explicitly listed";
      appTimeouts =
        mkNixtraOption (lib.types.listOf idleKillerConcurrentAppSubmodule) [ ]
        "Apps that should be checked for inactivity concurrently; with a separate timer";
      killMethod = mkNixtraOption (lib.types.enum [ "pid" "pkill" ]) "pid"
        "The kill method that should be used to stop apps";
      killGrace = mkNixtraOption lib.types.int 30
        "How long to wait after SIGTERM before SIGKILL (in seconds)";
      hyprctlBatch = mkNixtraOption lib.types.bool false
        "Whether the service should optimize hyprctl calls per loop to avoid spamming compositor. The scripts already minimize hyprctl calls by caching results per loop, so this should not be needed.";
    };
  };
}
