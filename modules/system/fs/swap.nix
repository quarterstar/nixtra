{ settings, ... }:

if settings.disk.swap.enable then {
  swapDevices = [{
    device = "/swapfile";
    randomEncryption.enable = settings.disk.encryption.enable;
    size = settings.disk.swap.size;
  }];
} else
  { }
