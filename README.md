# Daniel W's Dotfiles

Makes it easy to setup new machines, or reinstalling new OS, and get right back to work.

The zshrc will:
1. Automatically install if not exist the latest versions of  
  a. Lazydocker  
  b. Lazygit  
  c. Golang Compiler  
  d. Miniconda with latest Python  
  e. NVM and install and use Node LTS  
  f. Neovim  
  g. Git delta  
  h. Yazi (Terminal File Explorer)  
  i. Fzf  
  j. Lazysql  
  Everything will be installed from github source to get the latest release, because apt package's version tends to be left behind too much. 
2. Apply Git delta to .gitconfig
3. Install zsh plugins and snippets using zinit, including fzf-tab, zsh-completions and autosuggestions, fast-syntax-highlting. Snippets from Oh My Zsh
4. Install powerlevel10k
5. A lot of my custom functions and aliases

My Neovim:
1. Based on Lazyvim, with a lot of extra plugins

My Tmux Config:
1. Very nice clipboard integration with WSL2, and regular xclip because i do use both WSL and native Linux

## Instruction
1. Clone
2. Stow

## Additional Conditional Files Template/Cheatsheet

### ~/.clangd
```yaml
CompileFlags:
  Add:
    - "-Iinclude"
```

### ~/.gitconfig
```toml
[user]
	email = danielwiratman@gmail.com
	name = Daniel Wiratman

[core]
  longpaths = true
  pager = delta

[interactive]
  diffFilter = delta --color-only

[delta]
  navigate = true

[merge]
  conflictstyle = diff3

[diff]
  colorMoved = default
```

### secrets.sh
```bash 
export OPENAI_API_KEY=

alias conndo="sshpass -p 123123 ssh -p 22 daniel@example.com"
```


### Polkit rules for DWM thunar automount
`cat /etc/polkit-1/rules.d/10-udisks2.rules`
```
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
         action.id == "org.freedesktop.udisks2.filesystem-mount") &&
        subject.isInGroup("storage")) {
        return polkit.Result.YES;
    }
});
```

Not Yet Integrated: Install flutter and android studio

### If use arch install these
paru -S sshpass ueberzug ytfzf imv mpv zathura-pdf-mupdf qpwgraph peazip cups system-config-printer clang cmake ninja google-chrome code thunderbird dnsutils redshift ddgr avahi nss-mdns wmname paru ibus ibus-autostart ibus-daemon ibus-libpinyin

### Change natural scrolling for touchpad in arch
/etc/X11/xorg.conf.d/30-touchpad.conf
```
Section "InputClass"
        Identifier "devname"
        Driver "libinput"
        MatchIsTouchpad "on"
        Option "Tapping" "on"
        Option "NaturalScrolling" "true"
EndSection
```

git clone https://github.com/BennyOe/onedark.yazi.git ~/.config/yazi/flavors/onedark.yazi

Add this to /etc/nsswitch.conf
```
hosts: files mdns_minimal [NOTFOUND=return] dns
```

Add this to /etc/avahi/avahi-daemon.conf
```
[server]
host-name=daniel
...
publish-workstation=yes
```

Update Pacman Mirrorlist
```
sudo reflector --country Indonesia --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --connection-timeout 30
```
