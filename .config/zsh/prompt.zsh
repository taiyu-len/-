setopt PROMPT_SUBST
setopt AUTO_NAME_DIRS

# https://github.com/taiyu-len/shrink-path
# https://github.com/taiyu-len/my-git-prompt
__my_ps1='%(1j.%F{m}%j%f%%.)%(?..%F{red}%?%f)'

function zle-line-init zle-keymap-select {
	local e;
	if test "$KEYMAP" = vicmd
	then PS1="$__my_ps1< "
	else PS1="$__my_ps1> "
	fi
	zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

PS1="$__my_ps1> "
RPS1='%B $(shrink-path "${(D)PWD}")$(my-git-prompt)%b'
PS2="%_ "
PS3="?# "

