{ profile, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      mimeClass = if profile.user.browser == "librewolf" then
        "librewolf.desktop"
      else if profile.user.browser == "firefox" then
        "firefox.desktop"
      else if profile.user.browser == "chrome" then
        "google-chrome.desktop"
      else
        "";
    in {
      "text/html" = mimeClass;
      "x-scheme-handler/http" = mimeClass;
      "x-scheme-handler/https" = mimeClass;
      "x-scheme-handler/about" = mimeClass;
      "x-scheme-handler/unknown" = mimeClass;
    };
  };
}
