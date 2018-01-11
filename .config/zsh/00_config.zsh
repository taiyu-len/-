export REPORTTIME=60 # print statistics for commands longer then 60 seconds
export WORDCHARS=''
export DIRSTACKSIZE=20
setopt printexitvalue
setopt nobeep
setopt interactive_comments

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

setopt pushdignoredups
setopt autopushd

setopt autocd # type directory name to change to it
setopt extendedglob # regular expresssion globbing

# Infinite history size,
# enables start, end meta data.
# use shared history between ttys
export HISTFILE="$HOME/.zsh/history"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt HIST_BEEP

if [[ $TERM == "linux" ]]
then
	export PS1="%(1j.%j .)%# "
	export RPS1="%~"
else
	export PS1="%B%F{w}%K{b}%S%(1j.%j .)%s%k%b%f "
	export RPS1="%B%F{w}%K{b}%S %~ %s%k%f"
	# remove spacing
	export ZLE_RPROMPT_INDENT=0
fi
