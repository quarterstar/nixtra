{ pkgs, ... }:

{
  systemd.services."delete-cliphist" = {
    description = "Run a custom task at shutdown";
    wantedBy = [ "shutdown.target" ]; # Ensures it runs during shutdown
    before = [ "shutdown.target" ]; # Run before most shutdown tasks
    serviceConfig = {
      Type = "oneshot"; # Run once and exit
      RemainAfterExit = false; # Don't remain active after execution
      ExecStop = "${pkgs.writeShellScript "delete-cliphist.sh" ''
        cliphist wipe
      ''}";
    };
  };
}
