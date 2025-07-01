#!/bin/bash

# Installation script for modular ZSH configuration

echo "Installing modular ZSH configuration..."

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
  echo "Backing up existing .zshrc to .zshrc.backup"
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Create symlink to new zshrc
echo "Creating symlink to new zshrc"
ln -sf "$HOME/dotfiles/zsh/zshrc.new" "$HOME/.zshrc"

echo "Installation complete!"
echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes."