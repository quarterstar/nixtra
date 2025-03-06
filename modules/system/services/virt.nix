{ profile, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    virtiofsd
  ];

  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # For shared directories on Windows guests
  services.samba.enable = true;
  services.samba.settings = {
    shared = {
      path = "/home/${profile.user.username}/Volumes/win11-re";
      browseable = "yes";
      "read only" = "no";
    };
  };

  # Clipboard sharing
  services.spice-vdagentd.enable = true;
}
