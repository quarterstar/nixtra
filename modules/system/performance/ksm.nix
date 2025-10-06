{ ... }:

{
  hardware.ksm = {
    enable = true;
    sleep = 100;
  };

  boot.kernel.sysctl = {
    "vm.ksm.pages_to_scan" = 1000;
    "vm.ksm.merge_across_nodes" = 1;
  };
}
