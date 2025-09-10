{ lib, nixtraLib, ... }:

{
  options.nixtra.desktop.flagship-hyprland = {
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
  };
}
