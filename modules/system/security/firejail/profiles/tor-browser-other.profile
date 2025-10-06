ignore noinput
ignore net
ignore memory-deny-write-execute
ignore noexec ${HOME}
ignore seccomp
ignore seccomp.block-secondary
ignore private-cache
ignore restrict-namespaces

include /etc/firejail/common.inc
include /etc/firejail/gtk.inc

whitelist ${HOME}/.tor-browser-en
whitelist ${HOME}/.config/torbrowser
whitelist ${HOME}/.cache/torbrowser
whitelist ${HOME}/.local/share/torbrowser

private-bin bash,grep,sed,tail,tor-browser-en,env,id,readlink,dirname,test,mkdir,ln,sed,cp,rm,getconf,file,expr
private-etc X11,pulse,ssl,resolv.conf,fonts
