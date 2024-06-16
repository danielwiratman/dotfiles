#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
	xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Display Resolution
xrandr --output Virtual-1 --mode 1920x1080 &

set_wallpaper() {
	if [[ -f /usr/bin/ponywall && -f /usr/bin/magick ]]; then
		homedir=$HOME/.config/ponywall
		if [ -f $homedir/pwall_composite.jpg ]; then
			feh --bg-fill $homedir/pwall_composite.jpg
		elif [ -f $homedir/pwall.jpg ]; then
			feh --bg-fill $homedir/pwall.jpg
		else
			feh --bg-fill ~/wallpapers/black.jpg
		fi
		ponywall -f
		magick -background '#00000080' -fill white -font Lato-Regular -pointsize 24 label:@$homedir/pwall.txt miff:- | composite -gravity south -geometry +600+32 - $homedir/pwall.jpg $homedir/pwall_composite.jpg
		feh --bg-fill $homedir/pwall_composite.jpg
	else
		feh --bg-fill ~/wallpapers/lofi-room.jpg
	fi
}

# Run the function in the background
set_wallpaper &

# Compositor
picom &

# SlStatus
slstatus &

# Thunar Daemon
thunar --daemon &

# Clipmenu
systemctl --user import-environment DISPLAY
clipmenud &

# Obsidian
if [[ -f /usr/bin/obsidian ]]; then
	obsidian &
fi

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

ibus-daemon -rxRd

# Execute DWM
exec dwm
