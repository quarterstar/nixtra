{ settings, ... }:

{
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.interval = "monthly";
  services.btrfs.autoScrub.fileSystems =
    [ "/" ]; # Only need to scrub the topmost subvolume

  fileSystems."/".options = [ "compress=zstd" "noatime" "autodefrag" ]
    ++ (if settings.disk.ssd then [ "ssd" ] else [ ]);
  fileSystems."/boot".options = [ "fmask=0022" "dmask=0022" ];

  # alternatively use `discard` filesystem option
  services.fstrim.enable = true;
}
