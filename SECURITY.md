# Security

> [!IMPORTANT]
> Nixtra is open source software and its developers and contributors are in no way liable for any security vulnerabilities discovered in Nixtra's components, its packages or its dependencies.

## About Nixtra

### Security Programs, Features & Services

- Secure Boot
- Full Disk Encryption
- Encrypted Swap
- Filesystem Impermanence
- Hardened Linux Kernel
- Strict Kernel Parameters
- Hardened Kernel Packages
- Restricted and Reduced Modules
- Sandboxed Core Systemd Services
- Restricted USB Access with USBGuard
- DNS Leak Prevention
- OpenSnitch
- Hardened Nix Firewall
- Fail2ban
- Automatic Security Audits
- Automatic, Unattended Security Upgrades
- SOPS-Nix
- Immutable users
- Sandboxed Userspace Apps with Firejail
- AppArmor (TODO)
- SELinux (TODO)
- Auditd
- Wazuh
- Zeek
- Graylog

### Imperativity

Almost all of Nixtra's components are declared and managed by NixOS; however, certain aspects—specifically those related to initial disk setup—are done in an imperative way via the installer. This is done for two reasons, one being that using `disko` would make it very difficult to manage all permutations of disk installations (considering choice of filesystem, full disk encryption, and impermanence), and because most users will not have to repeat these steps more than once for any installation of a Nixtra system. If you want to use extra features for security like btrfs subvolumes in conjunction with impermanence, you will need to add your own code.

### Backwards Compatibility & Deprecation

In the case where a superior alternative to a current Nixtra solution for a problem is discovered, the following procedure based on a 2-release window cycle will take place:

If an option that exists in mainstream Nixtra is superceded, a warning shall appear in the following Nixtra release, and it is to be completely removed from the codebase two releases afterwards. The goal with this migration plan is to allow users to recursively update their system to the latest release, so that they get the patches from each one individually, without polluting upstream with deprecated functionality.

If an option is related to a security risk imposed by Nixtra, the same procedure as the one above follows, but instead of a warning, the user shall get a hard error.

## Information for Users

### Security Considerations

- Do NOT set your password or secrets in NixOS modules! Nix generates `.drv` files after building which may contain the password, allowing anyone to view it worldwide. Instead, either use SOPS or provide secrets to programs imperatively.

## Information for Contributors

Nixtra comes with a lot of packages pre-installed. As such, it is possible for a security vulnerability to be discovered in any of them at any time. Below is our standard procedure protocol and some tips to help us mitigate such scenarios.

### Guidelines

- If the vulnerability affects the specific version of the package, and a fixed version has not yet been released or added to the upstream Nixpkgs channel, please open an issue request specifically mentioning the problematic version.
- If a program becomes unmaintained or made obsolete by a successor, open an issue request describing your proposed alternative.
- If a security vulnerability is caused by Nixtra's code, send me a private e-mail with a PoC and ancillary information.

### Enhancements

- If you believe a program would greatly benefit from sandboxing, consider making a pull request to sandbox the program with firejail or any other supported containment solution.
    - If you believe that a program would benefit from being used over an anonymity network like Tor, consult the pre-existing Nixtra configuration to make it use that service and open a PR for it.
