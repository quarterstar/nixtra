{ config, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = config.nixtra.desktop.mimeapps;
  };
}
