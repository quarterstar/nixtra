{ pkgs, ... }:

{
  # Enable display manager
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  environment.systemPackages = with pkgs; [
    wayland
    wayland-protocols
    plymouth # Display manager dependency
    xorg.libX11   # Optional, for XWayland fallback
    xorg.libxcb   # Optional

    # Utils
    swayimg # Display images
    clipman # Copy text to clipboard
    cliphist # View clipboard history
    wl-clipboard # Watch event for clipboard
  ];
}
