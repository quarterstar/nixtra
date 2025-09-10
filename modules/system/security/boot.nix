{ settings, ... }:

if settings.security.protectBoot then {
  # https://madaidans-insecurities.github.io/guides/linux-hardening.html#boot-parameters
  boot.kernelParams = [
    # procfs hardening
    "proc.hidepid=2"
    "gid=proc"

    # make it harder to influence slab cache layout
    "slab_nomerge"
    # enables zeroing of memory during allocation and free time
    # helps mitigate use-after-free vulnerabilaties
    "init_on_alloc=1"
    "init_on_free=1"
    # randomizes page allocator freelist, improving security by
    # making page allocations less predictable
    "page_alloc.shuffel=1"
    # enables Kernel Page Table Isolation, which mitigates Meltdown and
    # prevents some KASLR bypasses
    "pti=on"
    # randomizes the kernel stack offset on each syscall
    # making attacks that rely on a deterministic stack layout difficult
    "randomize_kstack_offset=on"
    # disables vsyscalls, they've been replaced with vDSO
    "vsyscall=none"
    # disables debugfs, which exposes sensitive info about the kernel
    "debugfs=off"
    # certain exploits cause an "oops", this makes the kernel panic if an "oops" occurs
    "oops=panic"
    # only alows kernel modules that have been signed with a valid key to be loaded
    # making it harder to load malicious kernel modules
    # can make VirtualBox or Nvidia drivers unusable
    "module.sig_enforce=1"
    # prevents user space code excalation
    "lockdown=confidentiality"
    # "rd.udev.log_level=3"
    # "udev.log_priority=3"
  ];

  # https://madaidans-insecurities.github.io/guides/linux-hardening.html#kasr-kernel-modules
  boot.blacklistedKernelModules = [
    # Obscure networking protocols
    "dccp" # Datagram Congestion Control Protocol
    "sctp" # Stream Control Transmission Protocol
    "rds" # Reliable Datagram Sockets
    "tipc" # Transparent Inter-Process Communication
    "n-hdlc" # High-level Data Link Control
    "ax25" # Amateur X.25
    "netrom" # NetRom
    "x25" # X.25
    "rose"
    "decnet"
    "econet"
    "af_802154" # IEEE 802.15.4
    "ipx" # Internetwork Packet Exchange
    "appletalk"
    "psnap" # SubnetworkAccess Protocol
    "p8023" # Novell raw IEE 802.3
    "p8022" # IEE 802.3
    "can" # Controller Area Network
    "atm"
    # Various rare filesystems
    "cramfs"
    "freevxfs"
    "jffs2"
    "hfs"
    "hfsplus"
    "udf"

    # "squashfs"  # compressed read-only file system used for Live CDs
    # "cifs"  # cmb (Common Internet File System)
    # "nfs"  # Network File System
    # "nfsv3"
    # "nfsv4"
    # "ksmbd"  # SMB3 Kernel Server
    # "gfs2"  # Global File System 2
    # vivid driver is only useful for testing purposes and has been the
    # cause of privilege escalation vulnerabilities
    # "vivid"
  ] ++ (if settings.security.disableUsbStorage then [ "usb_storage" ] else [ ]);
} else
  { }
