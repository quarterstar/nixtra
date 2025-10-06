ignore memory-deny-write-execute
ignore nosound
ignore no3d

include /etc/firejail/common.inc

whitelist ${HOME}/.config/mpv

private-bin mpv
private-etc mpv,alternatives,fonts
