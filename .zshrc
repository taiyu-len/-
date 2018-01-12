clear
source "$HOME/.bashrc"
#{ Options
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
#}
#{ History
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
#}
#{ Prompt
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
#}
#{ Completions
zstyle ':completion:*' completer _extensions _complete _match _prefix _ignored _correct _approximate
zstyle ':completion:*' menu select # better selection
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # use same colors as ls command
zstyle ':completion:*' group-name '' #group options by description

zstyle ':completion:*:descriptions' format '%F{7}%U%B== %d ==%b%u%f'
zstyle ':completion:*:messages' format '%F{7}$U%d$u%f'
zstyle ':completion:*:warnings' format '%Bno matches for: %d%b'

zstyle ':completion:*' use-cache on # enable completion cache
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"

zstyle ':completion:*' hosts off # disable usings hosts file because its huge

zstyle ':completion:*:cd:*' ignore-parents parent pwd

autoload -Uz compinit
compinit

compdef _gnu_generic zenity
#}
#{ KeyBinds
#{ Map Ctrl-Z to call fg
# via http://git.grml.org/?p=grml-etc-core.git;a=blob_plain;f=etc/zsh/zshrc;hb=HEAD
function grml-zsh-fg() {
	if (( ${#jobstates} )); then
		zle .push-input
		[[ -o hist_ignore_space ]] && BUFFER=' ' || BUFFER=''
		BUFFER="${BUFFER}fg"
		zle .accept-line
	else
		zle -M 'No background jobs.'
	fi
}
zle -N grml-zsh-fg
bindkey '^z' grml-zsh-fg
#}
#{ Fix pasted urls
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic
#}
#{ .... => ../../..
function rationalise-dot {
	if [[ $LBUFFER = *.. ]]
	then LBUFFER+=/..
	else LBUFFER+=.
	fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
#}
#{ Fix special characters
typeset -A key
function {
	autoload zkbd
	function zkbd_file {
		[[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
		[[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
		return 1
	}

	mkdir -p ~/.zkbd
	local keyfile=$(zkbd_file)
	if [[ $? == 1 ]]
	then
		zkbd
		keyfile=$(zkbd_file)
	fi
	if [[ $? == 0 ]]
	then source "${keyfile}"
	else printf 'Failed to setup keys using zkbd.\n'
	fi
	unfunction zkbd_file
}
#}
#{ set mappings
bindkey -v # vim mode

[ "${key[Home]}"           ]  && bindkey "${key[Home]}"           beginning-of-line
[ "${key[End]}"            ]  && bindkey "${key[End]}"            end-of-line
[ "${key[Insert]}"         ]  && bindkey "${key[Insert]}"         overwrite-mode
[ "${key[Delete]}"         ]  && bindkey "${key[Delete]}"         delete-char
[ "${key[Up]}"             ]  && bindkey "${key[Up]}"             up-line-or-history
[ "${key[Down]}"           ]  && bindkey "${key[Down]}"           down-line-or-history
[ "${key[Left]}"           ]  && bindkey "${key[Left]}"           backward-char
[ "${key[Right]}"          ]  && bindkey "${key[Right]}"          forward-char
[ "${key[Shift-Left]}"     ]  && bindkey "${key[Shift-Left]}"     backward-char
[ "${key[Shift-Right]}"    ]  && bindkey "${key[Shift-Right]}"    forward-char
[ "${key[Ctrl-Up]}"        ]  && bindkey "${key[Ctrl-Up]}"        history-beginning-search-backward
[ "${key[Ctrl-Down]}"      ]  && bindkey "${key[Ctrl-Down]}"      history-beginning-search-forward
[ "${key[Ctrl-Left]}"      ]  && bindkey "${key[Ctrl-Left]}"      backward-word
[ "${key[Ctrl-Right]}"     ]  && bindkey "${key[Ctrl-Right]}"     forward-word
[ "${key[PageUp]}"         ]  && bindkey "${key[PageUp]}"         beginning-of-buffer-or-history
[ "${key[PageDown]}"       ]  && bindkey "${key[PageDown]}"       end-of-buffer-or-history
[ "${key[Ctrl-Backspace]}" ]  && bindkey "${key[Ctrl-Backspace]}" backward-delete-word
[ "${key[Ctrl-Delete]}"    ]  && bindkey "${key[Ctrl-Delete]}"    delete-word
[ "${key[Alt-H]}"          ]  && bindkey "${key[Alt-H]}"          run-help
[ "${key[Shift-Tab]}"      ]  && bindkey "${key[Shift-Tab]}"      reverse-menu-complete
#}
#}
#{ Suffix Alias
alias -s {png,jpg,jpeg,gif}=feh
alias -s {3gp,avi,mkv,mp4,webm}=mpv
alias -s {pdf,epub}=mupdf
alias -s exe=wine
#}
#{ Functions
function mkcd() {
	mkdir -p "$*"
	cd "$*" || exit
}
compdef mkcd=mkdir

function tmpcd() {
	cd $(mktemp -d)
}

function track() {
	local tags=()
	while [[ "$1" = @* ]]
	do tags+="${1/@/}"; shift
	done
	if ! hash ${1:?Requires at least one function to call} &>/dev/null
	then echo "Requires a valid function to call" >&2; return 1
	fi
	timew start "${tags:-$(basename $1)}"
	"$@"
	timew stop
}

function tat {
	tmux new-session -As "${@:-$(basename $PWD)}"
}
function tsplit {
	tmux split-window "$@"
}
#{ neat curl things
function wttr {
	curl "wttr.in/${*}"
}
function cheat.sh {
	curl "cheat.sh/$*"
}
#}
#{ run-help for builtins
unalias run-help &> /dev/null
autoload run-help
#}
#}

daily_message
# vim: foldmarker=#{,#} foldmethod=marker
