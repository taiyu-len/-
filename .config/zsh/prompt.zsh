setopt PROMPT_SUBST
setopt AUTO_NAME_DIRS

__my_git_prompt() {
	$(git rev-parse --is-inside-work-tree 2>/dev/null) || return 0
	# https://github.com/taiyu-len/my-git-prompt
	git status -bs --porcelain=v2 2>/dev/null | my-git-prompt
}
__my_ps1='!%!%(1j. %%%j.)%(?.. ?%?) $(shrink-path "${(D)PWD}")$(__my_git_prompt)'

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
# https://github.com/taiyu-len/shrink-path
PS2="%_ "
PS3="?# "

