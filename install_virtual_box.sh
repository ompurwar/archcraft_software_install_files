
#!/bin/zsh

# Function to check the exit status of the last command and exit if it failed
check_exit_status() {
    if [ $? -ne 0 ]; then
        echo "An error occurred. Exiting..."
        exit 1
    fi
}

# Remove any existing VirtualBox installation
echo "Removing existing VirtualBox installation (if any)..."
sudo pacman -Rns virtualbox virtualbox-host-dkms --noconfirm
check_exit_status

# Reinstall VirtualBox with DKMS support
echo "Reinstalling VirtualBox with DKMS support..."
sudo pacman -Syu --needed virtualbox virtualbox-host-dkms --noconfirm
check_exit_status

# Rebuild DKMS modules
echo "Rebuilding DKMS modules..."
sudo dkms autoinstall
check_exit_status

# Check DKMS status
echo "Checking DKMS status..."
sudo dkms status

# Load the vboxdrv module
echo "Loading vboxdrv module..."
sudo modprobe vboxdrv
check_exit_status

# Confirm the module is loaded
echo "Checking if vboxdrv module is loaded..."
if lsmod | grep -q vboxdrv; then
    echo "vboxdrv module loaded successfully."
else
    echo "Failed to load vboxdrv module. Please check the logs."
    exit 1
fi

# Start VirtualBox
echo "Starting VirtualBox..."
virtualbox &
check_exit_status

echo "VirtualBox setup completed successfully."
