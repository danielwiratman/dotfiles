# Daniel W's Dotfiles

## Instruction
1. Clone
2. Stow

## Example Files

### .clangd
```yaml
CompileFlags:
  Add:
    - "-I/home/daniel/development/postgresql-16.1/src/include"
    - "-I/home/daniel/development/postgresql-16.1/include"
```

### .gitconfig
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
  navigate = true    # use n and N to move between diff sections

[merge]
  conflictstyle = diff3

[diff]
  colorMoved = default
```

### secrets.sh
```bash 
export OPENAI_API_KEY=

alias conndo=""
alias connss=""
```

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

paru -S ueberzug ytfzf imv mpv zathura-pdf-mupdf qpwgraph peazip cups system-config-printer clang cmake ninja google-chrome code thunderbird dnsutils redshift


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
