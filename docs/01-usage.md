# Nixtra - Usage

Congratulations on installing Nixtra! To get you fully settled in, below you will find information about general usage of your new system. Please refer to the corresponding section for your selected window manager, desktop manager or other environment.

## Table of Contents

- [Commands](##commands)
- [Applications](##applications)
- [Keybindings](##keybindings)

## Commands

Nixtra provides a set of custom commands to make managing NixOS easy. Below are the most important ones:

- `nixtra-rebuild`: Rebuild the system according to its configuration in `/etc/nixos`.
- `nixtra-update`: Update your system and its dependencies.
- `nixtra-clean`: General system cleanup; clean up logs, Nix store, Nix cache, etc.
- `nixtra-record`: Start a video recording of the entire screen or a region.
- `nixtra-screenshot`: Take a screenshot of the entire screen or a region.
- `nixtra-create-iso`: Generate an ISO file based on your Nixtra configuration.
- `nixtra-fix-bootloader`: Automatically troubleshoot and fix the bootloader, if it breaks and your system does not boot.
- `nixtra-regen-hardware`: Regenerate the configuration describing the hardware used by the system; graphics card, mount points etc.

You can find more of them by checking for commands with the following prefixes:

- `nix-`: Commands related to the Nix package manager.
- `nixos-`: Commands related to the Nix Operating System (NixOS).
- `nixtra-`: Commands related to the Nixtra configuration for NixOS.

## Keybindings

> [!IMPORTANT]
> All window managers and desktop environments are configured to adhere to the standard shortcuts used by Nixtra, listed below respectively. If you are using a modified version of Nixtra, these may not apply.

### Window Manager

- <kbd>SUPER</kbd> + <kbd>WHEEL</kbd>: Switch to next or previous workspace.
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> +  <kbd>V</kbd>: Cycle through clipboard history.
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> <kbd>S</kbd>: Take a screenshot of a specific region of the window. (Stored in `~/Pictures/Screenshots`)
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> R</kbd>: Start/stop recording a specific region of the window. (Stored in `~/Videos/Screencasts`)
- <kbd>SUPER</kbd> + <kbd>S</kbd>: Take a screenshot of the entire window. (Stored in `~/Pictures/Screenshots`)
- <kbd>SUPER</kbd> + <kbd>R</kbd>: Start/stop recording the entire window. (Stored in `~/Videos/Screencasts`)
- <kbd>SUPER</kbd> + <kbd>C</kbd>: Pick a color from the screen.
- <kbd>SUPER</kbd> + <kbd>N</kbd>: Switch from vertical tiling to horizontal or vice versa for active window.
- <kbd>SUPER</kbd> + <kbd>F</kbd>: Toggle fullscreen.
- <kbd>SUPER</kbd> + <kbd>Q</kbd>: Create new window.
- <kbd>SUPER</kbd> + <kbd>Z</kbd>: Close active window.
- <kbd>SUPER</kbd> + <kbd>M</kbd>: Log out of active user.
- <kbd>SUPER</kbd> + <kbd>Function</kbd>: Switch workspace.
- <kbd>SUPER</kbd> + <kbd>V</kbd>: Toggle floating window mode.
- <kbd>SUPER</kbd> + <kbd>Right</kbd>: Increase volume by 5%.
- <kbd>SUPER</kbd> + <kbd>Left</kbd>: Decrease volume by 5%.
- <kbd>SUPER</kbd> + <kbd>Down</kbd>: Toggle volume mute.
- <kbd>SUPER</kbd> + <kbd>,</kbd>: Switch to left workspace.
- <kbd>SUPER</kbd> + <kbd>.</kbd>: Switch to right workspace.

> [!NOTE]
> `SUPER` is the Windows key on most keyboards.

### Desktop Environment

Nixtra does not yet support any desktop environment.

## AI Integration

Since a lot of people use AI for quick-and-dirty debugging nowadays, Nixtra has out-of-the-box tools for it fresh from the oven. Nixtra divides these inference tools into two categories; completion and chatting.

### AI Code Completion

Nixtra supports code completion suggestions - from an LLM of your choice - right inside your terminal. Currently, this feature is supported for the Kitty terminal emulator because, instead of having a standalone completion program like other tools, the Kitty API is used to make it feels more "native."

As such, a tool was specifically developed for Nixtra, [kittyai](https://github.com/quarterstar/kittyai), which is a descendant of the [GPTKitten](https://github.com/TIAcode/GPTKitten), because it supports more API providers and more features.

To use this tool, press `CTRL` `SHIFT` `I` in a Kitty window and enter your desired query in a comment. For example:

```
$ # Greet the user
> echo "Hello there, user!"
```

### AI Chatting

## Applications

### Tor Browser

In Nixtra, Tor Browser is provided in three different flavors, each used for different scenarios. These can be located in the taskbar of the selected window manager or desktop environment of your choice, as shown with the corresponding icons below:

**<img width="32" height="32" src="../assets/icons/tor-browser-clearnet.png"> Clearnet Tor Browser**

This flavor disables the built-in Tor routing and instead acts like a normal browser, without any sort of proxy. This means that you cannot access .onion hidden services with this flavor.

This flavor is ideal if you want simple browsing with privacy but not the anonymity that regular Tor provides.

**<img width="32" height="32" src="../assets/icons/tor-browser-proxy.png"> Proxy Tor Browser**

This flavor replaces the built-in Tor proxy to use a chain of proxies. The first proxy in the chain is the Tor service, which is functionally equivalent to the regular Tor Browser. However, the second proxy in the chain is a public proxy of your choice, which is right after the exit node. The chain of proxies looks like this:

<img alt="Layout of Tor Browser Proxy profile" width="486" height="187" src="../web/assets/tor-browser-proxy-layout.png">

The purpose of this flavor is to mask the exit node's IP address so that websites that block Tor do not know you are using Tor. Unlike Tor bridges, which bypass censorship by putting a private proxy in between you and the guard (entry) node, this flavor provides a proxy in between the exit node and the destination website.

This is ideal if you want to log into websites like Reddit, which bans any Tor users that it detects having an exit node IP address. The usage of this flavor should ideally be restricted to ONLY your online identity, as any other website that sees the public proxy in the back of the exit node will be able to associate your activity and hence with your online account(s).

**<img width="32" height="32" src="../assets/icons/tor-browser.png"> Regular Tor Browser**

This flavor is simply the regular Tor browser with a regular Tor connection, ideal for most anonymous activities. Unless otherwise specified in its connection settings, no additional proxy will be used.
