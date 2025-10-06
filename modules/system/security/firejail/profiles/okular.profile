ignore noinput

# required for qt/kvantum theme to work
ignore noroot
ignore nodbus
dbus-system none

include /etc/firejail/common.inc
include /etc/firejail/qt.inc

mkdir ${HOME}/.local/share/okular

whitelist ${HOME}/.config/okularpartrc
whitelist ${HOME}/.local/share/okular
whitelist ${HOME}/.local/state/okularstaterc
