ignore net none
ignore nosound
ignore novideo
ignore no3d
ignore memory-deny-write-execute
# ignore private-tmp
ignore apparmor
ignore noexec ${HOME}

include /etc/firejail/common.inc
include /etc/firejail/gtk.inc

whitelist ${HOME}/.config/discord

mkdir /tmp/user/1000/discord1000/

whitelist /tmp/.X11-unix
whitelist /tmp/user/1000/discord1000/
env TMPDIR=/tmp/user/1000/discord1000
