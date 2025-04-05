{ settings, ... }:

if settings.swap.enable then {
  swapDevices = [{
    device = "/swapfile";
    size = settings.swap.size * 1024; # 16GB
  }];
} else {}
