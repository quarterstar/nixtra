ignore net none

include /etc/firejail/common.inc

whitelist ${HOME}/.local/share/ssh

writable-run-user
join-or-start ssh

private-bin ssh
private-etc ssh,resolv.conf,nsswitch.conf,hosts,passwd
private-lib openssh

blacklist /usr/share/
