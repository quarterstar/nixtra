ignore private-tmp
ignore noinput
ignore memory-deny-write-execute

include /etc/firejail/common.inc
include /etc/firejail/gtk.inc

mkdir ${HOME}/.config/libreoffice

whitelist ${HOME}/.config/libreoffice

private-bin sh,dash,libreoffice,dirname,grep,uname,ls,sed,pwd,basename,dbus-launch,dbus-send,fcitx-dbus-watcher,fcitx-remote
private-etc libreoffice,fonts,passwd,alternatives,X11

whitelist /usr/share/libreoffice
whitelist /usr/share/icons
whitelist /usr/share/themes
whitelist /usr/share/fonts

whitelist /tmp/.X11-unix
# Enable document recovery
whitelist /tmp/user/1000
