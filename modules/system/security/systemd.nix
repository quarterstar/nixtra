{ config, lib, ... }:

{
  services.dbus.implementation = "broker";
  services.logrotate.enable = true;

  # disable coredump that could be exploited later
  # and also slow down the system when something crash
  systemd.coredump.enable = false;

  services.journald = {
    storage = if config.nixtra.debug.persistJournalLogs then
      "persistent"
    else
      "volatile";
    upload.enable = false; # Disable remote log upload (the default)
    extraConfig = ''
      SystemMaxUse=500M
      SystemMaxFileSize=50M
    '';
  };

  # Restrict log access to root
  security.pam.services.systemd-journal.requireWheel = true;

  # Spoof machine ID for services
  environment.etc."machine-id" =
    lib.mkIf config.nixtra.anonymity.spoofMiscIdentifiers {
      text = "00000000000000000000000000000000";
    };

  users.groups.netdev = { };
}
