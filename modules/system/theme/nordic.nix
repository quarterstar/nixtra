{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nordic ];

  environment.sessionVariables = {
    # Dark theme
    GTK_THEME = "Nordic";
  };

  environment.variables = {
    # Dark theme
    GTK_THEME = "Nordic";
  };
}
