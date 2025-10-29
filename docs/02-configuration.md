# Configuring Profiles

## Profiles

Profiles are the heart of Nixtra. They define your Nixtra configuration, installed packages, programs, and services. They can be found in the `profiles` directory, and each one has the following files:

- `profile.nix`: an attribute set containing your Nixtra configuration. Takes precedence over [presets](##Profile Presets).
- `configuration.nix`: a NixOS module used atop of Nixtra infrastructure. This is where you should import packages and services from the `modules/system` directory. It is recommended to keep it compendious and organize more specialized configuration in the `modules` directory.
- `homes/user.nix`: a Home Manager module containing configuration for your user profile. In this file, should import packages and services from the `modules/userspace` directory. Nixtra only uses one non-root profile.
- `homes/root.nix`: a Home Manager module containing configuration for your root profile. In this file, you should import packages and services from the `modules/userspace` directory. Packages and services specified in this file are not installed for the user profile.

It is recommended to have a different profile for each Nixtra machine, and you can have those profiles stored in a monolithic Git repository.

## Software Bundles

*Software Bundles* (or *bundles* for short) are predefined lists of quintessential software packages, programs, and services, for each respective categorial use case, curated by the Nixtra development team. The following bundles are provided, by default:

- `programming`
- `gaming`
- `mathematics`

Bundles can be mixed and composed by adding them to your `imports` list in the `configuration.nix` of your profile.

If you want your system to have a particular set of software pre-installed for your use case but you do not want your system particularly configured for that use case, use bundles.

## Profile Presets

*Profile Presets* (or *presets* for short) are predefined subsets of profile configurations that contain common configuration (e.g., for the kernel), installed packages, programs, and services, for each respective categorial use case. They can be found in the `presets` directory. The following presets are provided, by default:

- `programming`
- `gaming`

If you want your system to have a particular set of software pre-installed for your use case and you also want your system particularly configured for that use case, use presets.

## Custom Configuration

Nixtra already tries to cover its primary use cases, but obviously covering all of them is impossible, so this section is dedicated to proposing a pattern for you to follow to keep your copy of Nixtra's codebase tidy.

Nixtra's business logic is in the `modules` directory. This means that all core functionality, services, options, environment configuration, and more are stored in it. So whenever you updated Nixtra, most of the changes that affect you are done in this directory. Since the `profiles` directory is intended to be for you, changes to it made by your upstream repository can safely be ignored. But if you decide to modify the `modules` directory, that means you will need to make sure it does not conflict with future `git pull`s or automatic updates. To achieve this, what we recommend is that you create your own `modules` directory in your profiles directory, match the layout of the root `modules` directory, and import it in profiles as you wish. That way, not only do you signify that these changes are made specifically for your copy of Nixtra, but you prevent any code conflicts.

Suppose you wanted to add code that you want to push to Nixtra's main repository. In that case, making changes to `modules` is perfectly fine, if you are confident that these changes are suitable for all other Nixtra users. At that point, it is no longer about how you organize your configuration but contributing to the project, so if you are interested in this, refer to [CONTRIBUTING](CONTRIBUTING.md).

If you think this design pattern is not suitable for your use case, we have specifically designed our code to be approachable by newcomers, so you can simply hard fork our project and truly make it your own. But please be informed that doing this, as aforementioned, may prevent you from applying updates we supply you.
