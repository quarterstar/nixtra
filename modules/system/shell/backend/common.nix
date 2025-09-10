{ nixtraLib, config, pkgs, ... }:

let
  greeting = nixtraLib.command.createCommand {
    name = "greeting";
    prefix = "";
    buildInputs = with pkgs; [ fortune cowsay lolcat ];
    command = ''
      # Only run in interactive shells
      #[[ $- != *i* ]] && exit 0

      echo ""

      HOUR=$(date +%H)
      if (( HOUR >= 6 && HOUR < 12 )); then
        COW="tux"
      elif (( HOUR >= 12 && HOUR < 18 )); then
        COW="moose"
      elif (( HOUR >= 18 && HOUR < 22 )); then
        COW="dragon"
      else
        COW="ghostbusters"
      fi

      fortune | cowsay -f "$COW" | lolcat

      echo ""
    '';
  };
in {
  # want some fun?? :D
  programs.zsh.shellInit = if config.nixtra.fun.mysteriousFortuneCookie then
    "${greeting}/bin/greeting"
  else
    "";
}
