ignore noinput
ignore memory-deny-write-execute
ignore noexec ${HOME}
ignore private-cache

include /etc/firejail/common.inc

whitelist ${HOME}/.config/keepassxc
whitelist ${HOME}/.cache/keepassxc
