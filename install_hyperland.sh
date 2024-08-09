#!/bin/bash

# Function to print messages
print_message() {
  echo -e "\n\033[1;32m$1\033[0m\n"
}

# Ensure the system is up to date
print_message "Updating the system..."
sudo pacman -Syu --noconfirm

# Check if yay is installed, if not install it
if ! command -v yay &> /dev/null; then
  print_message "Yay not found, installing yay..."
  sudo pacman -S --needed git base-devel --noconfirm
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  print_message "Yay is already installed."
fi

# Install Hyperland
print_message "Installing Hyperland..."
yay -S hyperland --noconfirm

# Install necessary dependencies
print_message "Installing dependencies..."
sudo pacman -S wayland wayland-protocols wlroots xorg-xwayland --noconfirm

# Configure Hyperland
print_message "Configuring Hyperland..."
mkdir -p ~/.config/hyperland
if [ -f /etc/hyperland/config ]; then
  cp /etc/hyperland/config ~/.config/hyperland/
else
  print_message "Default config file not found. You might need to create the config manually."
fi

# Ensure the wayland-sessions directory exists
print_message "Creating wayland-sessions directory if it doesn't exist..."
sudo mkdir -p /usr/share/wayland-sessions

# Create a session file for display manager
print_message "Creating a session file for Hyperland..."
sudo bash -c 'cat > /usr/share/wayland-sessions/hyperland.desktop <<EOF
[Desktop Entry]
Name=Hyperland
Comment=A dynamic tiling Wayland compositor
Exec=Hyperland
Type=Application
EOF'

print_message "Hyperland installation and configuration complete. You can now select Hyperland from your display manager."

# End of script

