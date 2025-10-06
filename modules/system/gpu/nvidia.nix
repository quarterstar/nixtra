{ lib, config, ... }:

{
  config = lib.mkIf (config.nixtra.hardware.gpu == "nvidia") {
    hardware.graphics = { enable = true; };

    hardware.nvidia = {
      open = false;
      modesetting = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      prime.sync.enable = true;
    };

    # Ensure DRM and GBM support for Wayland
    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1"; # Useful workaround for cursor issues
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
    };

    # Required for NVIDIA Wayland support
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
