{ profile, ... }:

if profile.display.themeType != "" then {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" =
        if profile.display.themeType == "dark" then {
          color-scheme = "prefer-dark";
          gtk-application-prefer-dark-theme = true;
        } else
          { };
    };
  };
} else
  { }
