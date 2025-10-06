# Nixtra - Troubleshooting

## Environment errors

**sudo: /run/current-system/sw/bin/sudo must be owned by uid 0 and have the setuid bit set** / **doas: not installed setuid**

This error is caused when the setuid for the binaries is not set. In other words, when you inspect the permission flags in a terminal emulator with an affected environment (e.g. Hyprland), you may see something like:

```
> ls -l $(which doas)
lrwxrwxrwx 1 root root 63 Dec 31  1969 /run/current-system/sw/bin/doas -> /nix/store/wjw92v29a7969mkmx5zi0hxgdfzg74w2-doas-6.8.2/bin/doas
```

Contrary to the output in a TTY:

```
-r-s--x--x 1 root root 70720 Jun 30 06:16 /run/wrappers/bin/doas
```

To fix this, there are multiple workarounds. First, check if ZSH is the program causing this issue. In that case, to resolve it, all you have to do is delete `.zshrc` file and restart your computer:

```
rm ~/.zshrc
reboot
```

Another case is `/run/wrappers/bin` is missing from your `PATH` environment. You can check that with:

```
> echo "$PATH" | grep "/run/wrappers/bin"
/run/wrappers/bin:/run/wrappers/bin:/home/user/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/nix/store/dyyifi0w2g0ddfxv5xs6ihkgbr435qp2-kitty-0.42.1/bin:/nix/store/z4jnh4k7lmydfp6zcin84qy2j2v4w19i-imagemagick-7.1.1-47/bin:/nix/store/myw381bc9yqd709hpray9lp7l98qmlm1-ncurses-6.5-dev/bin:/home/user/.zsh/plugins/zsh-autocomplete
```

In this case, the command output is non-empty, which means that it exists, but if it does not, you can permanently set it for your terminal session with the following command:

```
export PATH=/run/wrappers/bin:$PATH
```

If that resolves the issue, you can make it persist by modifying your NixOS configuration according to your environment's requirements.

**`display-manager` service not starting, login managers not working, or window manager crashing**

In a new NixOS update, OpenGL issues have been noticed with Mesa. First, check if `/run/opengl-driver` exists on your system and is valid:

```
> ls -l /run/opengl-driver
```

If it does not exist, symptoms include, but are not limited to, `MESA-LOADER` errors, dri or GBM missing, etc.

TL;DR: A temporary fix for this is to add the following to your configuration:

```nix
system.activationScripts.tempFixMissingMesaSymlink = ''
  is_valid_symlink() {
    local p="$1"
    if [ -L "$p" ] && [ -e "$p" ]; then
      return 0
    else
      return 1
    fi
  }

  export OPENGL_PATH="/run/opengl-driver"

  if ! is_valid_symlink "$OPENGL_PATH"; then
    ln -s ${pkgs.mesa} /run/opengl-driver
  fi
'';
```

Normally, this should be done by `display-manager` or any other service if you have set `hardware.graphics.enable` to `true` and added `mesa` to `hardware.graphics.extraPackages`.
