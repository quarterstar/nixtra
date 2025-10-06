# Nixtra - Usage

Congratulations on installing Nixtra! To get you fully settled in, below you will find information about general usage of your new system. Please refer to the corresponding section for your selected window manager, desktop manager or other environment.

## Table of Contents

- [Commands](##commands)
- [Applications](##applications)
- [Keybindings](##keybindings)

## Commands

Nixtra provides a set of custom commands to make managing NixOS easy. Below are the most important ones:

**Basic**

- `nixtra-rebuild`: Rebuild the system according to its configuration in `/etc/nixos`.
- `nixtra-update`: Update your system and its dependencies.
- `nixtra-clean`: General system cleanup; clean up logs, Nix store, Nix cache, etc.
- `nixtra-check-security-status`: Do a full system security audit.
- `nixtra-record`: Start a video recording of the entire screen or a region.
- `nixtra-screenshot`: Take a screenshot of the entire screen or a region.
- `nixtra-create-iso`: Generate an ISO file based on your Nixtra configuration.
- `nixtra-fix-bootloader`: Automatically troubleshoot and fix the bootloader, if it breaks and your system does not boot.
- `nixtra-regen-hardware`: Regenerate the configuration describing the hardware used by the system; graphics card, mount points etc.
    - ⚠️ Nixtra manages your hardware configuration, so you should NOT manually override it in most circumstances.

**Advanced**

- `nixtra-unlock`: Make a home file managed by Home Manager no longer managed by it.
    - Arguments: `file`
    - Should be used for testing live configurations without the need for rebuilding.
    - Gets overwritten by a rebuild.
- `nixtra-enter-temp-fhs`: Get a temporary shell with an FHS (uses `steam-run`).
    - ⚠️ Should not be used as a permanent solution for fixing software that does not work properly in NixOS.
- `nixtra-hide-git-dir`: Run `git update-index --skip-worktree $FILE` recursively for an entire directory.
    - Arguments: `directory`
    - Use this if you want a directory to be hidden from the Git tree (so that it is not committed), but you still want it to be tracked by Nix Flakes.)
    - Undo the command's effect with `nixtra-unhide-git-dir`.

You can find more of them by checking for commands with the following prefixes:

- `nix-`: Commands related to the Nix package manager.
- `nixos-`: Commands related to the Nix Operating System (NixOS).
- `nixtra-`: Commands related to the Nixtra configuration for NixOS.

## Keybindings

> [!NOTE]
> `SUPER` is the Windows key on most keyboards.

### Window Manager

> [!IMPORTANT]
> All window managers in Nixtra must adhere to the standard shortcuts which are listed below, whenever possible.

**Primary**

- <kbd>SUPER</kbd> + <kbd>WHEEL</kbd>: Switch to next or previous workspace.

- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>M</kbd>: Log out of active user.
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> +  <kbd>V</kbd>: Cycle through clipboard history.
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> <kbd>S</kbd>: Take a screenshot of a specific region of the window. (Stored in `~/Pictures/Screenshots`)
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> R</kbd>: Start/stop recording a specific region of the window. (Stored in `~/Videos/Screencasts`)

- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>L</kbd>: Move the hovered window left.
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>H</kbd>: Move the hovered window right.
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>K</kbd>: Move the hovered window up.
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>J</kbd>: Move the hovered window down.

- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>ALT</kbd> + <kbd>L</kbd>: Scale the hovered window left.
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>ALT</kbd> + <kbd>H</kbd>: Scale the hovered window right.
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>ALT</kbd> + <kbd>K</kbd>: Scale the hovered window up.
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>ALT</kbd> + <kbd>J</kbd>: Scale the hovered window down.

- <kbd>SUPER</kbd> + <kbd>S</kbd>: Take a screenshot of the entire window. (Stored in `~/Pictures/Screenshots`)
- <kbd>SUPER</kbd> + <kbd>R</kbd>: Start/stop recording the entire window. (Stored in `~/Videos/Screencasts`)
- <kbd>SUPER</kbd> + <kbd>C</kbd>: Pick a color from the screen.
- <kbd>SUPER</kbd> + <kbd>N</kbd>: Switch from vertical tiling to horizontal or vice versa for active window.
- <kbd>SUPER</kbd> + <kbd>F</kbd>: Toggle fullscreen.
- <kbd>SUPER</kbd> + <kbd>Q</kbd>: Create new window.
- <kbd>SUPER</kbd> + <kbd>Z</kbd>: Close active window.
- <kbd>SUPER</kbd> + <kbd>G</kbd>: Open/close workspace manager; visual workspace selector.
- <kbd>SUPER</kbd> + <kbd>Function</kbd>: Switch workspace.
- <kbd>SUPER</kbd> + <kbd>V</kbd>: Toggle floating window mode.
- <kbd>SUPER</kbd> + <kbd>Right</kbd>: Increase volume by 5%.
- <kbd>SUPER</kbd> + <kbd>Left</kbd>: Decrease volume by 5%.
- <kbd>SUPER</kbd> + <kbd>Down</kbd>: Toggle volume mute.
- <kbd>SUPER</kbd> + <kbd>,</kbd>: Switch to left workspace.
- <kbd>SUPER</kbd> + <kbd>.</kbd>: Switch to right workspace.

**Overlays**

> [!IMPORTANT]
> If your keyboard does not have a Numpad, you can enable the Numpad compatibility setting in the profile config; this will allow you to use each respective number key with <kbd>SHIFT</kbd> instead of <kbd>KP</kbd>. For example, <kbd>SUPER</kbd> + <kbd>KP_1</kbd> will be replaced with <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>1</kbd>.

> [!NOTE]
> For convenience, these keys are written in Num Lock format, but you can use them with Num Lock disabled.

- <kbd>SUPER</kbd> + <kbd>KP_1</kbd>: Open ChatGPT container.
- <kbd>SUPER</kbd> + <kbd>KP_2</kbd>: Change the desktop wallpaper. (Picked from `~/Wallpapers`)
- <kbd>SUPER</kbd> + <kbd>KP_4</kbd>: Open or close screen-drawing with `gromit-mpx`.
- <kbd>SUPER</kbd> + <kbd>KP_5</kbd>: Clear `gromit-mpx` drawing buffer.
    - Undo last action with <kbd>Control_L</kbd> + <kbd>Z</kbd>; only works if drawing mode is open.

### Desktop Environment

> [!IMPORTANT]
> Nixtra does not yet support any desktop environment.

## AI Integration

> [!IMPORTANT]
> This feature set has not yet been implemented to Nixtra.

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

### LibreWolf — Regular Browsing

LibreWolf is a web browser and a fork of Firefox. By default, stock LibreWolf does not containerize opened tabs to have separate data, cookies, session, etc. To address this, several extensions have been created over the years, including Firefox Multi-Account Containers and Temporary Containers; the latter is the one we will focus on since it provides the features Nixtra needs.

Temporary Containers lets you create a new container for tabs you create. The problem with it is that Firefox does not give extensions permission to replace core keybinds like <kbd>Ctrl</kbd> + <kbd>T</kbd> (Create Tab) and <kbd>Ctrl</kbd> + <kbd>R</kbd> (Reload Tab). In Nixtra, special script configuration is used to override these core keybinds so that any tab opened with them gets its container.

In addition, Nixtra uses Tree Style Tabs for tab navigation, so additional scripts are used to override the tab creation functionality. To ensure that a tab is containerized, look for the "tmp" refix on the right of the search bar.

> [!WARN]
> For security reasons, Nixtra does not containerize the startup home page by default. To mitigate this, simply close the browser startup tab and open a new one with your desired destination.

### Tor Browser - Anonymous Browsing

Tor Browser is provided in three different flavors, each used for different scenarios. These can be located in the taskbar of the selected window manager or desktop environment of your choice, as shown with the corresponding icons below:

**<img width="32" height="32" src="./assets/icons/tor-browser-clearnet.png"> Clearnet Tor Browser**

This flavor disables the built-in Tor routing and instead acts like a normal browser, without any sort of proxy, ergo you cannot access `.onion` hidden services with this flavor. It is intended to be used as an alternative to our hardened LibreWolf configuration, if you want another means of simple browsing with privacy and security, but not the same level of anonymity that regular Tor provides; if you still want some anonymity, combining this one with a VPN like Mullvad may be ideal for you.

**<img width="32" height="32" src="./assets/icons/tor-browser-proxy.png"> Proxy Tor Browser**

This flavor replaces the built-in Tor proxy to use a chain of proxies. The first proxy in the chain is the Tor service, which is functionally equivalent to the regular Tor Browser. However, the second proxy in the chain is a public proxy of your choice, which is right after the exit node. The chain of proxies looks like this:

<img alt="Layout of Tor Browser Proxy profile" width="486" height="187" src="./displays/tor-browser-proxy-layout.png">

The purpose of this flavor is to mask the exit node's IP address so that websites that block Tor do not know you are using Tor. Unlike Tor bridges, which bypass censorship by putting a private proxy in between you and the guard (entry) node, this flavor provides a proxy in between the exit node and the destination website.

This is ideal if you want to log into websites like Reddit, which bans any Tor users that it detects having an exit node IP address. The usage of this flavor should ideally be restricted to ONLY your online identity, as any other website that sees the public proxy in the back of the exit node will be able to associate your activity and hence with your online account(s).

**<img width="32" height="32" src="./assets/icons/tor-browser.png"> Regular Tor Browser**

This flavor is simply the regular Tor browser with a regular Tor connection, ideal for most anonymous activities. Unless otherwise specified in its connection settings, no additional proxy will be used.
