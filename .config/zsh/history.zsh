test -v XDG_DATA_HOME && {
	ign_cmds=(ls cd "cd -" pwd exit date "* --help" "* -h" jobs fg bg htop ps "* /tmp*")
	HISTFILE="$XDG_DATA_HOME/zsh/history"
	HISTSIZE=1000000
	SAVEHIST=$HISTSIZE
	HISTORY_IGNORE="($(IFS='|'; printf %s "${ign_cmds[*]}"))"
	setopt NO_BANG_HIST
	setopt EXTENDED_HISTORY
	setopt INC_APPEND_HISTORY_TIME
	setopt HIST_EXPIRE_DUPS_FIRST
	setopt HIST_IGNORE_ALL_DUPS
	setopt HIST_IGNORE_SPACE
	setopt HIST_SAVE_NO_DUPS
	setopt HIST_NO_FUNCTIONS
	setopt HIST_NO_STORE # dont add history command to history
	setopt HIST_VERIFY
	setopt HIST_BEEP
	setopt HIST_REDUCE_BLANKS
}
