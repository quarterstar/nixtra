{ config, lib, pkgs, ... }:

{
  config = lib.mkIf
    (config.nixtra.display.enable && config.nixtra.display.theme == "nordic") {
      environment.systemPackages = with pkgs; [ nordic ];

      environment.sessionVariables = {
        # Dark theme
        GTK_THEME = "Nordic";
      };

      environment.variables = {
        # Dark theme
        GTK_THEME = "Nordic";
      };
    };
}
