# Enable native notifications.
dbus-user.talk org.freedesktop.Notifications
# Allow inhibiting screensavers.
dbus-user.talk org.freedesktop.ScreenSaver
# Allow screensharing under Wayland.
dbus-user.talk org.freedesktop.portal.Desktop

# minecraft.profile - Firejail profile for Minecraft

# Disable network access
#net none

# Restrict file access to only Minecraft-related directories
read-write /home/user/.local/share/PrismLauncher

# Disable access to the X11 server (to prevent GUI-based attacks)
# x11 none

# Drop unnecessary capabilities
caps.drop all

# Add any other custom restrictions here
