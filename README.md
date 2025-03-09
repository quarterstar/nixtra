# Nixtra

## Screenshots

TODO

## About Project

Nixtra is a fully-featured, hardened, extensible and well-documented NixOS configuration designed to:

- Provide me an ideal environment for: gaming; programming; the use of multimedia applications; security analysis and virtualization.
- Give me the ability to switch between different profiles in within a single user, each designated a different role, to prevent distractions and straighten my workflow.
- Harden the security of my system and implement sane defaults for opsec.
- Be easily understandable, customizable and extensible by other NixOS users interested in the use and/or further development of the configuration.
- Patch out the weird quirks that come with using NixOS on personal computers.

## Table of Contents

- [Features](#features)
- [Security Considerations](#security_considerations)
- [Security Practices](#security_practices)
- [User Accounts](#user)
- [Profiles Accounts](#profiles)
- [Configuration](#configuration)
- [Default Profiles](#default)
- [Project Structure](#project)
- [See Also](#see)
- [Credits](#credits)

## Features

- Pre-installed, beautifully-riced Hyprland window manager. (More in the future.)
- Different flavors of profiles pre-configured with a variety of packages to fullfill your needs.
- A, lot, and I mean a **LOT** of pre-baked fixes for common NixOS issues.
- High-level configuration system.

## Security Features

Some example security features Nixtra employs are:

- All permitted insecure packages may only be used under a profile with no networking enabled.
- `rm` is replaced with an alias of `trash` to prevent accidental permanent file deletion and many other aliases are included.
- Untrusted applications are encapsulated by a firejail wrapper to restrict their scope and permissions.
- Clipboard's buffer is cleared 10 seconds after being written, regardless of the application modifying it or the data being pasted.
- A set of sensitive applications like Tor Browser is pre-configured to automatically close upon the PC receiving a suspend signal.
- Sound access is disabled for Tor Browser.
- Certain software like Git can be configured to route all traffic through Tor for anonymity.

For a complete list, view [SECURITY.md](SECURITY.md).

## Installed Software

Nixtra is bundled with software for:

- Programming
- Web Development
- Security Researching
- Penetration Testing
- Reverse Engineering
- Gaming
- Virtualization
- Multimedia Applications
- Social Media Applications
- ...and more

All software provided by the mainstream Nixtra repository must strictly be free and open source software. Popular software packages and configurations for proprietary applications can exist but are to be commented out.

## Security Considerations

- Do NOT set your password or secrets in NixOS modules! Nix generates `.drv` files after building which may contain the password, allowing anyone to view it worldwide. Instead, either use SOPS or provide secrets to programs imperatively.

## User Accounts

This config is intended for single-user systems. A default `user` account configuration is provided. However, the user may pick a profile based on their software needs.

## Profiles

Nixtra is a single-user NixOS configuration, but the user may have multiple profiles. Profiles dictate what software shall be installed on your system, as well as how they shall be configured. For instance, you can have a personal profile, a work profile and a gaming profile each equipped with different or shared pieces of software.

## Configuration

Nixtra configuration comes in two flavors:

- `settings.nix`: Root system-level configuration dictating your hardware specifications and such. Shared amongst all profiles. Located at `settings.nix`.
- `profile-settings.nix`: Profile-specific user-level configuration. Located at `profiles/$PROFILE/profile-settings.nix`.

For configuring either of them, refer to the [Configuring Profiles]() section of the docs.

## Default Profiles

Nixtra provides the following default profiles:

| Profile     | Dependencies | Purpose
| ----------- | ------------ | -------
| `personal`  | `*`          | superset of all software available to profiles.
| `program`   | `math`       | subset of software needed to program + all math profile software.
| `exploit`   | -            | subset of software needed for vulnerability exploitation and analysis.
| `math`      | -            | subset of all software needed to study math.
| `untrusted` | -            | minimal profile that provides only absolutely necessary cli tools.

* If a profile has dependencies, it inherits all software and selections of each dependency but does not inherit their profile-specific `profile-settings.nix` configuration.

## Project Structure

Inside `modules`, the project uses the following directory hierarchy:

- `system`: all system-level services, applications and configurations.
- `userspace`: all the installed userspace applications and configurations.
- `config`: non-nix configurations for applications. [Read More](./docs/01-configuration.md)

## See Also

- [My easy-to-use framework for building hardened, customizable and extensible NixOS routers](https://github.com/quarterstar/nixter)
- [My notes for NixOS and computer science -related topics](https://github.com/quarterstar/notes)

## Credits

- [Wallpaper](https://steamcommunity.com/sharedfiles/filedetails/?id=3323190978)
- [Firejail Overlay](https://github.com/stelcodes/nixos-config/blob/main/packages/overlay.nix)
- [Waybar Record Module](https://gist.github.com/raffaem/bb9c35c6aab663efd7a0400c33d248a1)
