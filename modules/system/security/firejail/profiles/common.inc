blacklist /boot
blacklist /lib/firmware
blacklist /lib/modules
blacklist /sys/kernel
blacklist /sys/fs
blacklist /etc/modprobe.d
blacklist /etc/ld.so.conf
blacklist /etc/ld.so.conf.d
blacklist /etc/modules
blacklist /proc/sys/kernel/yama/ptrace_scope
blacklist /proc/kcore
blacklist /proc/kallsyms
blacklist /proc/config.gz
blacklist /sys/firmware

hostname sandbox

private-tmp
private-cache
read-only /tmp/.X11-unix
private-dev
noprinters
nodvd
noinput
nosound
notv
nou2f
novideo
no3d
disable-mnt
private-opt emp
private-srv emp

#shell none
seccomp
seccomp.block-secondary
noroot
caps.drop all
apparmor
nonewprivs
ipc-namespace
machine-id
nodbus
nogroups
net none
netfilter
memory-deny-write-execute

restrict-namespaces
# note: unix protocol must be specified here for any sandboxed app to work
protocol unix,inet,inet6

noexec ${HOME}
noexec /tmp
noexec $RUNUSER
