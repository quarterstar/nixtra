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
