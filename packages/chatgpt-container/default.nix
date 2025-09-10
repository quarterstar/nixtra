(pkgs.writeShellScriptBin "firefox-alt" ''
  exec ${pkgs.firefox}/bin/firefox \
    -kiosk \
    --no-remote \
    --profile "$HOME/.mozilla/firefox-alt"
    -P chatgpt
    -kiosk -no-remote -P chatgpt --new-window
'')
