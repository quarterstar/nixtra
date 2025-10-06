ignore noinput
ignore memory-deny-write-execute
ignore private-cache

include /etc/firejail/common.inc
include /etc/firejail/gtk.inc

whitelist ${HOME}/Wallpapers
whitelist ${HOME}/.cache/waypaper
whitelist ${HOME}/.config/waypaper
