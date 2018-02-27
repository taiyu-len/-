#!/bin/sh
# Keybinds are formated in sxhkdrc like
# |## Description
# |Mod + Keybind + {a,b,c}
# The sed script grabs both lines, seperates them by a tab and passes it into column to format it.
script='/^#{{{/{
	s/^#{{{ \(.*\)/======== \1 ========/
	p
	s/./=/g; p
}
/^## /{
	N
	s/^## \(.*\)\n\(.*\)/\1\t\2/
	p
}'
sed -ne "$script" ~/.config/sxhkd/sxhkdrc | column -ts $'\t'
