#!/bin/bash

# Function to print messages
print_message() {
  echo -e "\n\033[1;32m$1\033[0m\n"
}

# Check for curl or wget
if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
  echo "Error: curl or wget is required to download NVM."
  exit 1
fi

# Download and install NVM
print_message "Downloading and installing NVM..."
if command -v curl &> /dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
elif command -v wget &> /dev/null; then
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
fi

# Load NVM into the current shell session
print_message "Loading NVM..."
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Add NVM to shell startup file
print_message "Adding NVM to shell startup file..."
if [ -n "$BASH_VERSION" ]; then
  PROFILE_FILE="$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
  PROFILE_FILE="$HOME/.zshrc"
else
  PROFILE_FILE="$HOME/.profile"
fi

echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> $PROFILE_FILE
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> $PROFILE_FILE

# Source the profile file to apply changes
print_message "Applying changes..."
source $PROFILE_FILE

# Verify NVM installation
print_message "Verifying NVM installation..."
if command -v nvm &> /dev/null; then
  echo "NVM installed successfully. Version: $(nvm --version)"
else
  echo "Error: NVM installation failed."
  exit 1
fi

# Install latest LTS version of Node.js
print_message "Installing the latest LTS version of Node.js..."
nvm install --lts

# Verify Node.js installation
print_message "Verifying Node.js installation..."
if command -v node &> /dev/null; then
  echo "Node.js installed successfully. Version: $(node --version)"
else
  echo "Error: Node.js installation failed."
  exit 1
fi

print_message "NVM and Node.js installation completed successfully!"

