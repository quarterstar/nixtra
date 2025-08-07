{
  hardware = {
    gpu = "amd"; # Available options: amd
  };

  partitions = {
    boot = "/dev/disk/by-uuid/12CE-A600";
    storage = "/dev/disk/by-uuid/75f7fad7-0065-49a1-950c-ba5913eeae83";
  };

  encryption = {
    enable = true;
    decryptedRootDevice = "/dev/disk/by-uuid/ce341f6f-8daf-43d0-a034-901c93654118";
  };

  swap = {
    enable = true;
    size = 8 * 1024;
  };

  system = {
    arch = "x86_64-linux";
    hostname = "nixtra";
    timezone = { 
      auto = true; # If set to true, will ignore timezone.default
      default = "America/New_York";
    };
    locale = "en_US.UTF-8";
    version = "25.05";
    initialVersion = "25.05";

    filesystem = "btrfs";
    supportedFilesystems = [ "btrfs" "ext4" "ntfs" ];

    nur = false;
    hostnameProfilePrefix = true;
  };

  security = {
    extraUsers = [ "protected-documents" ];
  };

  config = {
    profile = "personal";
  };
}
