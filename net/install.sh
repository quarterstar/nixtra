#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash coreutils coreutils-full git e2fsprogs util-linux parted gnused

set -e  # Exit immediately if a command exits with a non-zero status

log_file="/var/log/nixtra.log"
default_partition_scheme="gpt"
default_boot="512MB"
default_use_swap="no"
default_swap="8GB"

# Trigger in case of error
trap "echo \"The installation failed because an error was received. Please check \"${log_file}\" for a detailed log.\"; umount -q -R /mnt; exit 1" ERR

trap "umount -q -R /mnt" EXIT

memory_size_is_valid() {
  local size=$1
  if [[ $size =~ ^[0-9]+(KB|MB|GB|TB)$ ]]; then
    return 0
  else
    return 1
  fi
}

write_property() {
  local filename=$1;
  local property=$2;
  local value=$3;

  sed -E "s/${property}\s*=\s*\"[^\"]*\";/profile = \"'\"$value\"'\";/" $filename >> "$log_file" 2>&1
}

echo -n "" > $log_file
uname -a >> $log_file
date >> $log_file
echo "" >> $log_file

echo "- Nixtra Installation Script -"
echo "- by quarterstar -"
echo "- https://github.com/quarterstar/nixtra -"
echo ""

echo "Welcome to the Nixtra installation script."
echo "To begin, below are the available devices on your system:"

echo ""
lsblk
echo ""

while true; do
  echo -n "Please enter the device you want Nixtra to be installed at (e.g. sda) "
  read device

  if ! [ -e "/dev/${device}" ] || [ -z "$device" ]; then
    echo "Device \"${device}\" does not exist."
  else
    break
  fi
done

while true; do
  echo -n "Please choose between GPT or MBR partition scheme [\"$default_partition_scheme\"] "
  read scheme

  if [ -z "$scheme" ]; then
    scheme="$default_partition_scheme"
  fi

  if ! [ "$scheme" = "gpt" ] && ! [ "$scheme" = "mbr" ]; then
    echo "Partition scheme \"${scheme}\" is invalid."
  else
    break
  fi
done

while true; do
  echo -n "Please enter desired boot partition size [\"$default_boot\"] "
  read boot

  if [ -z "$boot" ]; then
    boot="$default_boot"
  fi

  if ! memory_size_is_valid "$boot"; then
    echo "Memory size \"$boot\" is invalid."
  else
    break
  fi
done

while true; do
  echo -n "Would you like to set up swap memory? [\"${default_use_swap}\"] "
  read use_swap

  if [ -z "$use_swap" ]; then
    use_swap="$default_use_swap"
  fi

  if ! [ "$use_swap" = "yes" ] && ! [ "$use_swap" = "no" ]; then
    echo "Option \"$use_swap\" is invalid."
  else
    break
  fi
done

if [ "$use_swap" = "yes" ]; then
  while true; do
    echo -n "Please enter desired swap memory size [\"${default_swap}\"] "
    read swap

    if [ -z "$swap" ]; then
      swap="$default_swap"
    fi

    if ! memory_size_is_valid "$swap"; then
      echo "Memory size \"$swap\" is invalid."
    else
      break
    fi
  done
fi

while true; do
  echo -n "Please enter desired GPU drivers [\"amd\" | \"nvidia\" | \"none\"] "
  read gpu

  if ! [ "$gpu" = "amd" ] && ! [ "$gpu" = "nvidia" ] && ! [ "$gpu" = "none" ]; then
    echo "Graphics card \"$gpu\" is not supported."
  else
    break
  fi
done

while true; do
  echo -n 'Please select a profile ["personal" | "program" | "exploit" | "math" | "untrusted"] '
  read profile

  if ! [ "$profile" = "personal" ] && ! [ "$profile" = "program" ] && ! [ "$profile" = "exploit" ] && ! [ "$profile" = "math" ] && ! [ "$profile" = "untrusted" ]; then
    echo "Profile \"$profile\" does not exist."
  else
    break
  fi
done

echo "- Selected Options -"

echo "Device: ${device}"
echo "Partition scheme: ${scheme}"
echo "Boot partition size: ${boot}"

if [ "$use_swap" = "yes" ]; then
  echo "Swap size: ${swap}"
fi

echo "GPU: ${gpu}"
echo "Profile: ${profile}"

echo "--------------------"
echo "Are you SURE you want to continue? Installation is a destructive operation that will erase all existing data from the selected disk."
echo -n "Type \"continue\" to continue anyway: "

read consent

if ! [ "$consent" = "continue" ]; then
  echo "Cancelled installation."
  exit 0
fi

echo "Installation initiated. Feel free to take a coffee break - no more user input will be requested henceforth."

echo -n "Setting up partition scheme..."

if [ "$scheme" = "gpt" ]; then
  parted "/dev/${device}" -s -- mklabel gpt >> "$log_file" 2>&1

  storage_idx=1
  boot_idx=2

  if [ "$use_swap" = "yes" ]; then
    swap_idx=2
    boot_idx=3

    parted "/dev/${device}" -s -- mkpart root ext4 "$boot" "-$swap" >> "$log_file" 2>&1
    parted "/dev/${device}" -s -- mkpart swap linux-swap "-$swap" 100% >> "$log_file" 2>&1
  else
    parted "/dev/${device}" -s -- mkpart root ext4 "$boot" 100% >> "$log_file" 2>&1
  fi

  parted "/dev/${device}" -s -- mkpart ESP fat32 1MB "$boot" >> "$log_file" 2>&1
  parted "/dev/${device}" -s -- set $boot_idx esp on >> "$log_file" 2>&1
else
  parted "/dev/${device}" -s -- mklabel msdos >> "$log_file" 2>&1

  storage_idx=1
  boot_idx=2

  if [ "$use_swap" = "yes" ]; then
    swap_idx=3

    parted "/dev/${device}" -s -- mkpart primary "$boot" "-$swap" >> "$log_file" 2>&1
    parted "/dev/${device}" -s -- mkpart primary linux-swap "-$swap" 100% >> "$log_file" 2>&1
  else
    parted "/dev/${device}" -s -- mkpart primary "$boot" 100% >> "$log_file" 2>&1
  fi

  parted "/dev/${device}" -s -- set $boot_idx boot on >> "$log_file" 2>&1
fi

echo "done"
echo -n "Formatting partitions..."

if [ "$scheme" = "gpt" ]; then
  mkfs.ext4 -L nixos "/dev/${device}${storage_idx}" >> "$log_file" 2>&1
  if [ "$use_swap" = "yes" ]; then
    mkswap -L swap "/dev/${device}${swap_idx}" >> "$log_file" 2>&1
  fi
  mkfs.fat -F 32 -n boot "/dev/${device}${boot_idx}" >> "$log_file" 2>&1
else
  mkfs.ext4 -L nixos "/dev/${device}${storage_idx}" >> "$log_file" 2>&1
  if [ "$use_swap" = "yes" ]; then
    mkswap -L swap "/dev/${device}${swap_idx}" >> "$log_file" 2>&1
  fi
fi

echo "done"

echo -n "Mounting partitions..."

mount "/dev/disk/by-label/nixos" /mnt >> "$log_file" 2>&1

if [ "$scheme" = "gpt" ]; then
  mkdir -p /mnt/boot >> "$log_file" 2>&1
  mount -o umask=077 "/dev/disk/by-label/boot" /mnt/boot >> "$log_file" 2>&1
fi

echo "done"

if [ "$use_swap" = "yes" ]; then
  echo -n "Enabling swap..."
  swapon "/dev/${device}2" >> "$log_file" 2>&1
  echo "done"
fi

echo -n "Cloning nixtra repository..."

git clone https://github.com/quarterstar/nixtra /mnt/etc/nixos >> "$log_file" 2>&1

echo "done"

echo -n "Updating submodules..."

cd /mnt/etc/nixos
git submodule update --recursive --remote >> "$log_file" 2>&1
cd - > /dev/null

echo "done"

echo -n "Configuring..."

cd /mnt/etc/nixos
write_property "settings.nix" "gpu" $gpu
write_property "settings.nix" "profile" $profile
cd - > /dev/null

echo "done"

echo -n "Generating hardware config..."
nixos-generate-config --show-hardware-config > /mnt/etc/nixos/modules/system/hardware-configuration.nix 2>&1
echo "done"

echo -n "Installing nixtra (will take a while)..."
nixos-install --root /mnt --flake /mnt/etc/nixos#default >> "$log_file" 2>&1
echo "done"
