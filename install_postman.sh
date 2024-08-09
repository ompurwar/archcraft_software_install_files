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

# Install Postman
print_message "Installing Postman..."
yay -S postman-bin --noconfirm

print_message "Postman installation complete. You can now launch Postman from your application menu or by running 'postman' in the terminal."

# End of script

