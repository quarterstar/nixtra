# Security Policy

> [!IMPORTANT]
> Nixtra is open source software and its developers and contributors are in no way liable for any security vulnerabilities discovered in Nixtra's components, its packages or its dependencies.

Nixtra comes with a lot of packages pre-installed. As such, it is possible for a security vulnerability to be discovered in any of them at any time. Below is our standard procedure protocol and some tips to help us mitigate such scenarios.

## Guidelines

- If the vulnerability affects the specific version of the package, and a fixed version has not yet been released or added to the upstream Nixpkgs channel, please open an issue request specifically mentioning the problematic version.
- If a backdoor is added to a program, open an issue request with a list of all correlated packages made by the author of the backdoor.
- If a program becomes unmaintained or made obsolete by a successor, open an issue request comprised of alternative software.

## Enhancements

- If you believe a program would greatly benefit from sandboxing, consider making a pull request to sandbox the program with firejail or any other supported containment solution.
    - If you believe that a program would benefit from being used over an anonymity network like Tor, consult the pre-existing Nixtra configuration to make it use that service and open a PR for it.
