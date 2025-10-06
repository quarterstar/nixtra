ignore noinput
ignore no3d
ignore net none
ignore noexec /tmp
ignore memory-deny-write-execute # required to detect java versions
ignore noexec ${HOME}
ignore nosound

include /etc/firejail/common.inc
include /etc/firejail/qt.inc

whitelist ${HOME}/.local/share/PrismLauncher
