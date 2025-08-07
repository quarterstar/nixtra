{ pkgs, ... }:

{
  # udev hidraw rules to make motion controls and other things work with controllers in games
  # also fix mouse accel for model o
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "ds4";
      text = ''
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0660", TAG+="uaccess"
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0660", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/60-input.rules";
    })
    (pkgs.writeTextFile {
      name = "mouse-acceleration";
      text = ''
        ACTION=="add|change", SUBSYSTEM=="input", ATTR{name}=="Glorious Model O", ENV{LIBINPUT_NO_ACCELERATION}="1"
      '';
      destination = "/etc/udev/rules.d/50-mouse-acceleration.rules";
    })
  ];
}
