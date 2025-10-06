ignore seccomp
ignore seccomp.block-secondary
ignore noroot
ignore caps.drop all
ignore apparmor
ignore nonewprivs
ignore net none
ignore memory-deny-write-execute

include /etc/firejail/common.inc

caps.keep net_raw

private-etc hosts,resolv.conf,nsswitch.conf
private
quiet
