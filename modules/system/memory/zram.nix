{ config, lib, ... }:

{
  config = lib.mkIf config.nixtra.memory.zram.enable {
    zramSwap = {
      enable = true;
      memoryPercent = 50;
      priority = 100; # guaranteed higher priority than disk swap
    };

    boot.initrd.kernelModules = [ "zram" ];
  };
}
