#!/bin/zsh

# Function to install a package using pacman
install_package() {
  if ! pacman -Qs $1 > /dev/null; then
    echo "Installing $1..."
    sudo pacman -S --noconfirm $1
  else
    echo "$1 is already installed."
  fi
}

# Install zsh and necessary packages
install_package zsh
install_package git
install_package fzf

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh-my-zsh is already installed."
fi

# Install zsh-autosuggestions plugin
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
else
  echo "zsh-autosuggestions is already installed."
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
else
  echo "zsh-syntax-highlighting is already installed."
fi

# Install powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "Installing powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
else
  echo "powerlevel10k is already installed."
fi

# Configure .zshrc
echo "Configuring .zshrc..."

cat << 'EOF' >> ~/.zshrc
# Enable plugins and theme
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)

# Enable completion features
autoload -Uz compinit
compinit

# Source powerlevel10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Additional zsh-autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Set fzf to use zsh completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF configuration for better completion experience
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_ALT_C_COMMAND='fd --type d'
export FZF_CTRL_R_OPTS='--sort --height 40% --layout=reverse --border'

# Use fuzzy completion for bash
autoload -U bashcompinit
bashcompinit

# Key bindings for fzf
bindkey '^R' fzf-history-widget
bindkey '^T' fzf-file-widget
bindkey '^C' fzf-cd-widget

# zsh-autocomplete configuration
source ~/.oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Source plugins
source $ZSH/oh-my-zsh.sh
EOF

# Source the .zshrc to apply changes
source ~/.zshrc

echo "Zsh setup complete! Please restart your terminal or run 'zsh' to start using the new configuration."
