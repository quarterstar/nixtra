ignore memory-deny-write-execute
ignore noinput

include /etc/firejail/common.inc
include /etc/firejail/gtk.inc

whitelist ${HOME}/.thunderbird/
