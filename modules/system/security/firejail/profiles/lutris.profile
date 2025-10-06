ignore noinput
ignore no3d
ignore net none

ignore restrict-namespaces

ignore seccomp
ignore seccomp.block-secondary

ignore noroot
ignore nodbus
dbus-system none

ignore memory-deny-write-execute

include /etc/firejail/common.inc
include /etc/firejail/qt.inc
include /etc/firejail/wine.inc

mkdir ${HOME}/Games

whitelist ${HOME}/.config/lutris
whitelist ${HOME}/.local/share/lutris
whitelist ${HOME}/.cache/lutris
whitelist ${HOME}/Games
