{ pkgs, ... }:

let
  newline = { type = "custom"; format = ""; };
in {
  programs.fastfetch.enable = true;
  programs.fastfetch.settings = {
    logo = {
      width = 32;
      height = 20;
      source = "/etc/nixos/assets/logo.png";
      padding = {
        bottom = 1;
        right = 1;
      };
    };
    display = {
      size = {
        binaryPrefix = "si";
      };
      color = "blue";
      separator = "  ";
    };
    modules = [
      newline
      newline

      {
        type = "os";
        key = " OS";
      }
      {
        type = "kernel";
        key = " Kernel";
      }
      {
        type = "de";
        key = " DE";
      }
      {
        type = "shell";
        key = " Shell";
      }
      {
        type = "cpu";
        key = " CPU";
      }
      {
        type = "gpu";
        key = " GPU";
      }

      newline

      {
        type = "custom";
        format = " https://github.com/quarterstar/nixtra";
      }
    ];
  };
}
