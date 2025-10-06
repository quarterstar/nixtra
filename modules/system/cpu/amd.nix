{ lib, config, ... }:

{
  config = lib.mkIf (config.nixtra.hardware.cpu == "amd") {
    hardware.cpu.amd.updateMicrocode = true;
  };
}
