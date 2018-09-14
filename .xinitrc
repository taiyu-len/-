#!/bin/bash
{
	try() { hash "$1" && "$@" ;}
	src() { [ -x "$1" ] && . "$1" ;}
	if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
		eval "$(dbus-launch --sh-syntax --exit-with-session)"
	fi
	echo "$DBUS_SESSION_BUS_ADDRESS" > ~/.cache/dbusaddr
	/usr/bin/xdg-user-dirs-update

	if [ -d /etc/X11/xinit/xinitrc.d ]
	then
		for f in /etc/X11/xinit/xinitrc.d/*
		do src "$f"
		done
		unset f
	fi
	# Load Xresources
	test -f ~/.Xresources && xrdb -load "$_"

	# swap escape and capslock keys
	test -f ~/.Xmodmap && xmodmap "$_"
	try xcape

	# enable japanese Input
	if hash uim-xim
	then
		export GTK_IM_MODULE='uim'
		export QT_IM_MODULE='uim'
		export XMODIFIERS='@im=uim'
		uim-xim &
	fi
	try xrandr --output LVDS1 --above VGA1
	try xflux  -l 49&
	try urxvtd -qof
	try qjoypad&
	src ~/.fehbg
	xset -b on # enable bell
} >/dev/null 2>&1
#exec i3
#exec herbstluftwm
exec bspwm
