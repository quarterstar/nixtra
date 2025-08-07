{ createCommand, ... }:

createCommand {
  name = "enter-temp-fhs";
  buildInputs = [ ];

  command = ''
    nix-shell -p steam-run --command "steam-run bash"
  '';
}
