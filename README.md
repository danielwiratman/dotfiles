# Daniel W's Dotfiles

A modular dotfiles setup for quick and efficient system configuration.

## Features

- **Modular ZSH Configuration**: Organized into separate files for better maintainability
- **Auto-Installation**: Automatically installs latest versions of essential tools
  - Lazydocker, Lazygit, Golang, Miniconda, NVM, Neovim, Git delta, Yazi, Fzf, Lazysql
- **Plugin Management**: Uses Zinit for ZSH plugins and snippets
- **Custom Configuration**: Includes Neovim (Lazyvim-based) and Tmux with clipboard integration

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/danielwiratman/dotfiles.git ~/dotfiles
   ```

2. **Run the ZSH installer**:
   ```bash
   cd ~/dotfiles/zsh
   ./install.sh
   ```

3. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

## Additional Configuration

### Configuration Files
The following files will be automatically created if they don't exist:

- **~/.gitconfig**: Git configuration with delta integration
- **~/secrets.sh**: For storing API keys and private aliases

### Customization

To modify your ZSH configuration:
- Edit files in the appropriate subdirectory under `~/dotfiles/zsh/`
- For aliases: `aliases/aliases.zsh`
- For functions: `functions/functions.zsh`
- For paths: `exports/paths.zsh`

## Arch Linux Specific Setup

For Arch Linux users, there are additional configurations available:

### System Packages
```bash
paru -S sshpass ueberzug ytfzf imv mpv zathura-pdf-mupdf qpwgraph peazip cups system-config-printer clang cmake ninja google-chrome code thunderbird dnsutils redshift ddgr avahi nss-mdns wmname paru ibus ibus-autostart ibus-daemon ibus-libpinyin
```

### Touchpad Configuration
Create file at `/etc/X11/xorg.conf.d/30-touchpad.conf`:
```
Section "InputClass"
        Identifier "devname"
        Driver "libinput"
        MatchIsTouchpad "on"
        Option "Tapping" "on"
        Option "NaturalScrolling" "true"
EndSection
```

### Yazi Theme
```bash
git clone https://github.com/BennyOe/onedark.yazi.git ~/.config/yazi/flavors/onedark.yazi
```

### Network Configuration
For hostname resolution, update `/etc/nsswitch.conf` and `/etc/avahi/avahi-daemon.conf`.

### Utilities
- Update Pacman mirrors: `sudo reflector --country Indonesia --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist`
- Docker Hosts Updater is available for container hostname resolution
