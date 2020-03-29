setopt PROMPT_SUBST
setopt AUTO_NAME_DIRS

# https://github.com/taiyu-len/shrink-path
# https://github.com/taiyu-len/my-git-prompt
__my_ps1='!%!%(1j. %%%j.)%(?.. ?%?) $(shrink-path "${(D)PWD}")$(my-git-prompt)'

function zle-line-init zle-keymap-select {
	local e;
	if test "$KEYMAP" = vicmd
	then e="< "
	else e="> "
	fi
	PS1="$__my_ps1$e"
	zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

PS1="$__my_ps1> "
PS2="%_ "
PS3="?# "

