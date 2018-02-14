#!/bin/bash
{
	if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
		eval "$(dbus-launch --sh-syntax --exit-with-session)"
	fi
	/usr/bin/xdg-user-dirs-update

	if [ -d /etc/X11/xinit/xinitrc.d ]; then
		for f in /etc/X11/xinit/xinitrc.d/*; do
			[ -x "$f" ] && . "$f"
		done
		unset f
	fi
	test "$HOME/.Xresources" && xrdb -load "$_"

	# swap escape and capslock keys
	test "$HOME/.Xmodmap"  && xmodmap "$_"
	hash xcape && xcape

	# enable japanese Input
	if hash uim-xim; then
		export GTK_IM_MODULE='uim'
		export QT_IM_MODULE='uim'
		export XMODIFIERS='@im=uim'
		uim-xim &
	fi
	hash xrandr && xrandr --output LVDS1 --above VGA1
	hash xflux  && xflux -l 49 &
	test -x "$HOME"/.fehbg && . "$_"
	xset -b on # enable bell
} >/dev/null 2>&1
#i3
herbstluftwm
