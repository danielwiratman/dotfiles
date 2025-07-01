# Daniel's ZSH Configuration

This directory contains a modular ZSH configuration split into multiple files for better organization and maintainability.

## Structure

- `zshrc.new`: Main configuration file that sources all other files
- `config/`: Core configuration files
  - `installations.zsh`: Auto-installation of tools
  - `zinit.zsh`: Zinit plugin manager and plugins
  - `keybindings.zsh`: Keyboard shortcuts and history settings
- `exports/`: Environment variables and paths
  - `paths.zsh`: PATH and other environment variables
- `aliases/`: Command shortcuts
  - `aliases.zsh`: All command aliases
- `functions/`: Shell functions
  - `functions.zsh`: All shell functions
- `appearance/`: Terminal look and feel
  - `terminal.zsh`: Terminal appearance settings

## Installation

To use this modular configuration:

1. Backup your current `.zshrc`:
   ```bash
   cp ~/.zshrc ~/.zshrc.backup
   ```

2. Create a symlink to the new zshrc file:
   ```bash
   ln -sf ~/dotfiles/zsh/zshrc.new ~/.zshrc
   ```

3. Restart your terminal or run:
   ```bash
   source ~/.zshrc
   ```

## Customization

To modify your ZSH configuration:

- Edit the appropriate file in the corresponding directory
- For example, to add a new alias, edit `aliases/aliases.zsh`
- To add a new function, edit `functions/functions.zsh`
- To modify PATH variables, edit `exports/paths.zsh`

This modular approach makes it easier to maintain and update your ZSH configuration.