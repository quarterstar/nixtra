{ pkgs, ... }:

{
  gtk.cursorTheme = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
  };

  home.pointerCursor = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "BreezeX-RosePine-Linux";
      cursor-size = 24;
    };
  };
}
