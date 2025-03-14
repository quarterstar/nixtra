{ profile, ... }:

if profile.tor.enable then {
  services.tor = {
    enable = true;
    client.enable = true; # Enable Tor as a client
    torsocks.enable = true;

    # Change IP address every 10 seconds
    settings = {
      CircuitBuildTimeout = 10;
      LearnCircuitBuildTimeout = 0;
      MaxCircuitDirtiness = 10;
      #CookieAuthentication = true;
      #ControlPort = "auto";
      #ControlSocket = "/var/run/tor/control";
      #ControlSocketsGroupWritable = true;
    };

    # WARNING: may cause DNS leaks. Only use if absolutely necessary.
    #torsocks.allowInbound = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/run/tor 700 root root 10d"
  ];
} else {}
