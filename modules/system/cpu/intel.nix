{ lib, config, ... }:

{
  config = lib.mkIf (config.nixtra.hardware.cpu == "intel") {
    hardware.cpu.intel.updateMicrocode = true;
  };
}
