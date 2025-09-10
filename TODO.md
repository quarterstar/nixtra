# Features

- Implement `rkhunter` scans to `nixtra-check-security-status`
- Secure core systemd services with sandboxing
- Implement Graylog, Zeek, Wazuh
- Ask user in the installer for screen display resolution / fetch it automatically for apps that need to know it
- Ask user in the installer for VPN / Proxy configuration
- Reduce the number of pre-installed packages in profiles (to make the distro more lightweight)
- Use impermanence
- Separate `options` and `config` instead of defining `profile`
- Wipe clipboard history on shutdown
- Implement automatic config backup for each generation with encryption
- Add game to play during primary installation step
- Notify user when a shell alias is used for the first time

# Bugfixes

- Fix zsh taking too long to load Oh My Zsh
- Update documentation for new profile system
