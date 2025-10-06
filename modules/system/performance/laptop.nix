{ config, lib, ... }:

{
  config = lib.mkIf config.nixtra.hardware.laptop {
    services.tlp.enable = true;
    powerManagement.cpuFreqGovernor = "schedutil";
  };
}
