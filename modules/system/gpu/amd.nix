{ pkgs, ... }:

{
  # Enable AMD GPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];
    enable32Bit = true;
  };

  # hardware.opengl.driSupport deprecated

}
