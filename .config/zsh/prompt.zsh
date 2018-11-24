setopt PROMPT_SUBST
setopt AUTO_NAME_DIRS

__my_git_prompt() {
	$(git rev-parse --is-inside-work-tree 2>/dev/null) || return 0
	git status -bs --porcelain=v2 2>/dev/null |
	awk -f "$ZDOTDIR/prompt.awk"
}
function zle-line-init zle-keymap-select {
	local e;
	if test "$KEYMAP" = vicmd
	then e="< "
	else e="> "
	fi
	PS1='!%!%(1j. %%%j.)%(?.. ?%?) $(dirs -p|shrink-path)$(__my_git_prompt)'"$e"
	zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

PS1='!%!%(1j. %%%j.)%(?.. ?%?) $(dirs -p|shrink-path)$(__my_git_prompt)> '
# https://github.com/taiyu-len/shrink-path
PS2="%_ "
PS3="?# "

