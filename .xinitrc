#!/bin/bash
[ -x ~/.xprofile ] && . ~/.xprofile >/dev/null 2>&1

#exec i3
#exec herbstluftwm
exec bspwm
