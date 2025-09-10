# Nixtra- Cheatsheet

Congratulations for reaching this point! If you have installed Nixtra, that means you are ready to learn Nix more in-depth, which is a path that you will have to discover yourself. But to make the experience easier, below you will find a list of compiled information that you can reference any time you get confused.

I found that reading [this blog post](https://nixos-and-flakes-ja.hayao0819.com/nixos-with-flakes/nixos-with-flakes-enabled) and onward will explain some rudimentary concepts prety well, though that particular book is predominantly written in Japanese. You will find supplementary learning material below.

## Learning NixOS

- [nix-book](https://saylesss88.github.io)
- [Zero to Nix](https://zero-to-nix.com)
- [NixOS Modules Lessons](https://nixos-modules.nix.xn--q9jyb4c/)
- [nix.dev](https://nix.dev/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [The Nix lectures](https://ayats.org/blog/nix-tuto-1#the-nix-lectures-part-1-introduction-and-language-basics)

## Package Reference Websites

## Misc Resources

## NixOS Flakes & Module System

<img src="https://repology.org/graph/map_repo_size_fresh.svg">

**Flakes**

`/etc/nixos/flake.nix`: The entrypoint for the flake, which is recognized and deployed when sudo nixos-rebuild switch is executed.
`/etc/nixos/flake.lock`: The automatically generated version lock file, which records the data sources, hash values, and version numbers of all inputs in the entire flake, ensuring system reproducibility.

**Parameters**

(Source: [https://nixos-and-flakes-ja.hayao0819.com/nixos-with-flakes/nixos-flake-and-module-system](https://nixos-and-flakes-ja.hayao0819.com/nixos-with-flakes/nixos-flake-and-module-system))

NixOS modules have five automatically generated, automatically injected, and declaration-free parameters provided by the module system:

- `lib`: A built-in function library included with nixpkgs, offering many practical functions for operating Nix expressions.
    - For more information, see [https://nixos.org/manual/nixpkgs/stable/#id-1.4](https://nixos.org/manual/nixpkgs/stable/#id-1.4).
- `config`: A set of all options' values in the current environment, which will be used extensively in the subsequent section on the module system.
- `options`: A set of all options defined in all Modules in the current environment.
- `pkgs`: A collection containing all nixpkgs packages, along with several related utility functions.
    - At the beginner stage, you can consider its default value to be `nixpkgs.legacyPackages."${system}"`, and the value of pkgs can be customized through the nixpkgs.pkgs option.
    - More precisely, it is the result of importing `nixpkgs` and storing it into a variable `pkgs`.
- `modulesPath`: A parameter available only in NixOS, which is a path pointing to [nixpkgs/nixos/modules](https://github.com/NixOS/nixpkgs/tree/nixos-25.05/nixos/modules).
    - It is defined in [nixpkgs/nixos/lib/eval-config-minimal.nix#L43](https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/lib/eval-config-minimal.nix#L43).
    - It is typically used to import additional NixOS modules and can be found in most NixOS auto-generated `hardware-configuration.nix` files.
    - For instance, it can be used inside a NixOS module to refer to the NixOS installation media module: `imports = [ (modulesPath + "/installer/cd‑dvd/installation‑cd‑minimal.nix") ];`

You *do not* have to explicitely put them in the function signature if you have the ellipsis `...`, which manages any arguments you do not use.

**`config` argument vs. `config` attribute**

(Source: [https://nix.dev/tutorials/module-system/deep-dive](https://nix.dev/tutorials/module-system/deep-dive))

The `config` argument is *not* the same as the `config` attribute:

- The `config` argument holds the result of the module system’s lazy evaluation, which takes into account all modules passed to evalModules and their imports.
- The `config` attribute of a module exposes that particular module’s option values to the module system for evaluation.

## NixOS Modules vs. Home Manager

(Source: [https://nixos-and-flakes-ja.hayao0819.com/nixos-with-flakes/start-using-home-manager](https://nixos-and-flakes-ja.hayao0819.com/nixos-with-flakes/start-using-home-manager))

- NixOS Modules: Install system core components and other software packages or configurations needed by all users. For instance, if you want a software package to continue working when you switch to the root user, or if you want a configuration to apply system-wide, you should install it using NixOS Modules.
- Home Manager: Use Home Manager for all other configurations and software.

## `nixpkgs` Repository Structure

**pkgs/**

- `pkgs/`: Contains the vast majority of package definitions.
    - Organized hierarchically by categories (e.g., `development`, `applications`, `tools`, etc.).
    - Packages typically reside in `pkgs/<category>/<sub>/.../<pkgname>/default.nix` or `package.nix`.
    - Naming conventions: lowercase file/directory names with hyphens (e.g. `all-packages.nix`, not camelCase).

- `pkgs/by-name/`: A name-based shortcut layout that maps package attribute names directly to file paths, bypassing category hierarchy.
    - Directory structure: uses a two-letter prefix for grouping (e.g. `pkgs/by-name/so/some-package/package.nix`).
    - Automatically included without needing to edit `all-packages.nix`.

- `pkgs/top-level/`: This area orchestrates how packages are composed via Nixpkgs’s fixed-point.
    - `default.nix`: The primary module that brings everything together, defining package sets and entrypoints.
    - `stage.nix`: Chains together different build stages (e.g., bootstrapping environments and cross-compilation support).

**lib/**

- `lib/`: Contains the standard library for internal and downstream usage.
    - Common modules include: `lib.strings`, `lib.lists`, `lib.path`, `lib.fetchers`, `lib.generators`, etc.
    - It offers utilities for string processing, path normalization, derivation generation, fetch helpers, and more.

**nixos/**

- `nixos/modules/`: Houses system modules that define NixOS behavior (e.g., services, system options).
    - Overlays customization is supported via user-defined overlays in configs, allowing override or extension of `pkgs`.

**Summary**

| Directory / File Path          | Purpose                                                  |
| ------------------------------ | -------------------------------------------------------- |
| `pkgs/`                        | Main package categories and definitions                  |
| `pkgs/by-name/`                | Flat, name-based package mapping for convenience         |
| `pkgs/top-level/*`             | Orchestration, Nixpkgs bootstrapping, fixed-point stages |
| `lib/`                         | Standard library of utility functions and helpers        |
| `NixOS/modules/`               | System modules (services, configuration options)         |
| `default.nix` (root)           | Main entry point for imports and overlays                |
| `CONTRIBUTING.md`, `ci/`, etc. | Guidelines, CI tooling, and test infrastructure          |

[1]: https://releases.nixos.org/nixpkgs/nixpkgs-17.03pre91233.8d8f57d/manual/index.html?utm_source=chatgpt.com "Nixpkgs Contributors Guide"
[2]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/README.md?utm_source=chatgpt.com "nixpkgs/pkgs/by-name/README.md at master · NixOS/nixpkgs · GitHub"
[3]: https://nixos.org/manual/nixpkgs/stable/index.html?utm_source=chatgpt.com "Nixpkgs Reference Manual"
[4]: https://nixos.org/manual/nixpkgs?utm_source=chatgpt.com "Nixpkgs Reference Manual"

## `pkgs` Functions

**pkgs.callPackage**

(Source: [https://nix.dev/tutorials/callpackage](https://nix.dev/tutorials/callpackage))

hello.nix
```nix
{ writeShellScriptBin }:
writeShellScriptBin "hello" ''
  echo "Hello, world!"
''
```

default.nix
```nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.callPackage ./hello.nix { }
```

The argument `writeShellScriptBin` gets filled in automatically when the function in `hello.nix` is evaluated. For every attribute in the function's argument, `pkgs.callPackage` passes an attribute from the `pkgs` attribute set if it exists.

## Language Constructs

- `<entry>` (e.g. `<nixpkgs>`): a special path placeholder that represents the location of the `entry` repository in the Nix search path (`$NIX_PATH`)
    - For Nixpkgs, it is usually `/nix/var/nix/profiles/per-user/root/channels`

## Evaluation

**Configuration**

First, Nix gathers all `options` definitions from all modules. This gives it a complete picture of what can be configured. Then, it gathers all `config` definitions (including those wrapped in `lib.mkIf`) and merges them.

For example, when it encounters `lib.mkIf config.nixtra.audio.backend == "pipewire" { ... }`, it knows it needs the value of the `nixtra.audio.backend` option. It can determine this value based on its default value provided in `lib.mkOption` or any explicit assignment statements.

To better understand this, consider an example of circular dependencies: Nix is evaluating `modules/system/configuration.nix`. As part of this, it's trying to build the `imports` list. One line of `imports` contains the expression `(./audio + ("/" + config.nixtra.audio.backend) + ".nix")` To determine which file to import for audio, it needs the value of `config.nixtra.audio.backend`; however, the `config` argument in this module includes the configuration provided by the very modules it's trying to import. If `config.nixtra.audio.backend` is defined within one of the modules in the imports list (or if this module itself contributes to `nixtra.audio.backend`), then Nix needs to know `config.nixtra.audio.backend` to decide what to import, but `config.nixtra.audio.backend` can only be fully known after all modules (including the one being conditionally imported) are evaluated. This is a type of chicken and egg problem, and the only way to fix this is to make the import conditional.

**Phases**

Nix expressions are evaluated in two phases; evaluation time and build time.

Evaluation phase, which is done by the Nix interpreter, evaluates Nix expressions *lazily*. This means expressions are not evaluated when they are defined, but only when they are needed. For example, this happens when you explicitly access a value, when a package needs to be built, or when some computation requires it.

Consider the following example:

```nix
let
  x = throw "This will crash";
in
  42
```

This expression does not throw an error because `x` is never used, so it is *never* evaluated. During this phase, the interpreter processes expressions such as function calls, attribute lookups, string interpolations (like `"${pkgs.bash}/bin/bash"`), and derivation definitions. Importantly, derivations are only evaluated enough to describe what to build—for example, resolving their dependencies and build instructions—but not actually built yet.

Once the evaluation phase produces one or more derivations (the build instructions packaged as Nix expressions), Nix enters the build or realization phase. In other words, it knows what to build but has not yet.

This phase uses a special sandbox to ensure purity and reproducability. To see a real-world example of this in action, make your own derivation with `stdenv`, run a git clone command inside a build phase (shell code), and you will see that it fails to connect to the Internet because network access is restricted for build processes; furthermore, all of the following resources of the host are limited for derivations during realization:

- Access to the Internet (networking)
- Access to the Host File System (except the Nix store and explicitly allowed paths)
- Access to Environment Variables (restricted)
- Access to Devices
- Access to Sockets and IPC
- System Calls (depending on sandbox backend, e.g., sandboxfs and bubblewrap)

When you nix build, nix develop, etc., Nix realizes derivations into actual store paths. This includes downloading/building dependencies, running build scripts, etc. It also where `mkDerivation` fetches sources, compiles software, etc.

When you run the aforementioned commands, Nix takes the derivations and:

1. Downloads any required source files or dependencies
1. Executes build scripts (e.g., configure, make, ninja)
1. Installs the built artifacts into the Nix store
1. Produces the final outputs with fixed, immutable paths

## Nix Shell Commands

**nix-build**

Example:
```bash
nix-build '<nixpkgs/nixos>' -A config.system.build.toplevel
```

This is the command that builds Nix derivations — the low-level, reproducible build instructions.

- `<nixpkgs/nixos>`: This is a Nix expression path referring to a file inside the Nixpkgs repository, as explained in the Language Constructs section.
    - Specifically, `<nixpkgs/nixos>` points to: `$NIX_PATH/nixpkgs/nixos/default.nix`
    - This is the NixOS module system entry point, which sets up a full NixOS system configuration (not just a package).
- `-A config.system.build.toplevel`: This selects the specific attribute from the result of evaluating the Nix expression.
    - `-A` means "build this attribute"; that is, the attribute is a derivation.
    - `config` is the evaluated NixOS configuration (a huge attribute set).
    - `config.system.build.toplevel` is the actual derivation that builds the entire system closure (i.e. all packages, config files, systemd units, etc. needed for a NixOS system).
        - The `config.system.build.toplevel` derivation is generated by `nixpkgs/nixos/modules/system/activation/activation.nix`, specifically through a series of steps defined in various system-building functions.

This is the exact derivation that ends up being used by:

```bash
nixos-rebuild switch
```

It builds the full NixOS system you would boot into. In newer Nix syntax, this is identical to `nix build -f '<nixpkgs/nixos>' config.system.build.toplevel`.
