{ ... }:

{
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.interval = "monthly";
  services.btrfs.autoScrub.fileSystems =
    [ "/" ]; # Only need to scrub the topmost subvolume
}
