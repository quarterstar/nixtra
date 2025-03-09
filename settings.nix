rec {
  hardware = {
    gpu = "amd"; # Available options: amd
  };

  system = {
    arch = "x86_64-linux";
    hostname = "nixtra";
    timezone = "America/New_York";
    locale = "en_US.UTF-8";
    version = "24.11";
    initialVersion = "24.11";
    nur = false;
    hostnameProfilePrefix = true;
  };

  config = {
    profile = "personal";
  };
}
