#{ Startup Order
#{ Bash
# +----------------+-----------+-----------+------+
# |                |Interactive|Interactive|Script|
# |                |login      |non-login  |      |
# +----------------+-----------+-----------+------+
# |/etc/profile    |   A       |           |      |
# +----------------+-----------+-----------+------+
# |/etc/bash.bashrc|           |    A      |      |
# +----------------+-----------+-----------+------+
# |~/.bashrc       |           |    B  <------------- You are here
# +----------------+-----------+-----------+------+   configures the shell for interactive use
# |~/.bash_profile |   B1      |           |      |-.
# +----------------+-----------+-----------+------+ |
# |~/.bash_login   |   B2      |           |      |-+-Executes the first file found
# +----------------+-----------+-----------+------+ |
# |~/.profile      |   B3 <- this one is used ------'  sets global exports.
# +----------------+-----------+-----------+------+
# |BASH_ENV        |           |           |  A   |
# +----------------+-----------+-----------+------+
# |                |           |           |      |
# +----------------+-----------+-----------+------+
# |                |           |           |      |
# +----------------+-----------+-----------+------+
# |~/.bash_logout  |    C      |           |      |
# +----------------+-----------+-----------+------+
#}
#{ Zsh
# +----------------+-----------+-----------+------+
# |                |Interactive|Interactive|Script|
# |                |login      |non-login  |      |
# +----------------+-----------+-----------+------+
# |/etc/zshenv     |    A      |    A      |  A   |
# +----------------+-----------+-----------+------+
# |~/.zshenv       |    B      |    B      |  B   | -> /dev/null
# +----------------+-----------+-----------+------+
# |/etc/zprofile   |    C      |           |      |
# +----------------+-----------+-----------+------+
# |~/.zprofile     |    D      |           |      | -> .profile
# +----------------+-----------+-----------+------+
# |/etc/zshrc      |    E      |    C      |      |
# +----------------+-----------+-----------+------+
# |~/.zshrc        |    F      |    D      |      | -> .bashrc
# +----------------+-----------+-----------+------+
# |/etc/zlogin     |    G      |           |      |
# +----------------+-----------+-----------+------+
# |~/.zlogin       |    H      |           |      | prints message
# +----------------+-----------+-----------+------+
# |                |           |           |      |
# +----------------+-----------+-----------+------+
# |                |           |           |      |
# +----------------+-----------+-----------+------+
# |~/.zlogout      |    I      |           |      |
# +----------------+-----------+-----------+------+
# |/etc/zlogout    |    J      |           |      |
# +----------------+-----------+-----------+------+
#}
#}
#{ shell test
if  [[ "$0" =~ zsh || "$(basename "$0")" = .zshrc ]]  && [ "$ZSH_NAME" ]
then function is() { [ $1 = zsh  ] && { shift; "$@"; }; }
elif [[ "$0" =~ bash || "$(basename "$0")" = .bashrc ]] && [ "$BASH" ]
then function is() { [ $1 = bash ] && { shift; "$@"; }; }
else function is() { false; }
fi
#}
#{ Options
if is zsh #{
then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	REPORTTIME=60 # print statistics for commands longer then 60 seconds
	WORDCHARS=''
	DIRSTACKSIZE=20

	setopt PRINTEXITVALUE
	setopt NOBEEP
	setopt INTERACTIVE_COMMENTS
	setopt PUSHDIGNOREDUPS
	setopt AUTOPUSHD

	setopt AUTOCD # type directory name to change to it
	setopt EXTENDEDGLOB # regular expresssion globbing
fi #}
#}
#{ History
ign_cmds=(ls cd "cd -" pwd exit date "* --help" "* -h" jobs fg bg htop ps)
HISTSIZE=1000000
HISTFILE=
if is zsh #{
then
	# Infinite history size,
	# enables start, end meta data.
	# use shared history between ttys
	HISTFILE="$HOME/.zsh/history"
	SAVEHIST=$HISTSIZE
	HISTORY_IGNORE="($(IFS='|'; printf %s "${ign_cmds[*]}"))"
	setopt BANG_HIST
	setopt EXTENDED_HISTORY
	setopt INC_APPEND_HISTORY_TIME
	setopt HIST_EXPIRE_DUPS_FIRST
	setopt HIST_IGNORE_ALL_DUPS
	setopt HIST_IGNORE_SPACE
	setopt HIST_SAVE_NO_DUPS
	setopt HIST_VERIFY
	setopt HIST_BEEP
	setopt HIST_REDUCE_BLANKS
	#}
elif is bash #{
then
	HISTIGNORE="$(IFS=:; printf %s "${ign_cmds[*]}")"
	HISTCONTROL=ignoreboth
	HISTTIMEFORMAT=%s
	HISTFILE="$HOME/.bash_history"
fi #}
unset ign_cmds
#}
#{ Prompt
if is zsh #{
then
	ZLE_RPROMPT_INDENT=0
	setopt PROMPT_SUBST
	function my_git_status() { #{
		local b c s # branch_name, has changes to be commited, status of uncommited files
		typeset -A s
		{
			local line
			read line && b=$(sed -n 's/^## \(.*\)\.\.\..*/\1/;T;p' <<< $line)
			[ "$b" ] && while IFS= read line; do
				[[ ! "${line:0:1}" =~ '[ ?!]' ]] && c=+
				[[ "${line:0:1}" == 'A' ]] && ((++s[A]))
				((++s[${line:1:1}]))
			done
		} < <(git status -bs --porcelain=v1 2>/dev/null)
		local B="%F{blu}" R="%F{r}" G="%F{g}"
		printf "%s" "${b:+│ $c$b ${s[M]:+$B$s[M] }${s[A]:+$G$s[A] }${s[D]:+$R$s[D] }}"
	} #}
	PS_PREFIX='%B%K{black}%F{white}' PS_SUFFIX='%f%k%b'
	PS1="$PS_PREFIX%(1j.%j.)│$PS_SUFFIX $PS1_SUFFIX"
	RPS1="$PS_PREFIX"' %~ $(my_git_status)'"$PS_SUFFIX"
	[[ "$TERM" == "linux" ]] && PS1+=' '
	#}
elif is bash #{
then PS1='\w \$ '
fi #}
#}
#{ Completions
if is zsh
then
	# : completion : function : completer : command : argument : tag
	#
	# Completers to use.
	#zstyle ':completion:*' completer _expand _extensions _complete _ignored _correct _approximate _files
	zstyle ':completion:*' completer _extensions _expand _prefix _complete _ignored _correct _approximate
	#{ Display
	# Use colors for results
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # enable colors
	# Messages
	zstyle ':completion:*'              verbose true
	zstyle ':completion:*:descriptions' format '%F{6}%B== %U%d%u ==%b%f'
	zstyle ':completion:*:corrections'  format '%F{5}%B%d (errors: %e)%b%f'
	zstyle ':completion:*:warnings'     format '%F{6}%Bno matches for: %d%b%f'
	zstyle ':completion:*:messages'     format '%F{6}%B%d%b%f'
	zstyle ':completion:*:correct'      format '%F{6}%Bcorrected to: %U%e%u%b%f'
	zstyle ':completion:*:options'      auto-description '%d'
	zstyle ':completion:*:options'      description 'yes'
	# Group matches by descriptions
	zstyle ':completion:*'              group-name ''
	# Display more information for man pages
	zstyle ':completion:*:manuals'    separate-sections true
	zstyle ':completion:*:manuals.*'  insert-sections   true
	#}
	#{ Selection
	# Use menu by default
	zstyle ':completion:*'       menu select
	# use first menu choice right away
	zstyle ':completion:*:man:*' menu yes select
	#}
	#{ Generating
	# lowercase matches uppercase. aka smartcase
	zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
	# allow to match all or a matching file
	zstyle ':completion:*:expand:*' tag-order 'all-expansions expansions'
	# on processes completion complete all user processes
	zstyle ':completion:*:processes' command 'ps -a'
	#}
	#{ Corrections
	# allow 1 error per 3 characters
	zstyle -e ':completion:*:approximate:' max-errors 'reply=($(((3+$#PREFIX+$#SUFFIX)/3)) numeric)'
	zstyle    ':completion:*:expand:' keep-prefix true
	# ignore functions starting with _ when approximate matching
	zstyle  ':completion:*:(^approximate*):*:functions' ignored-patterns '_*'
	#}
	#{ Filtering
	# ignore cd ../$pwd
	zstyle ':completion:*:cd:*'   ignore-parents parent pwd
	zstyle ':completion:*:mkcd:*' ignore-parents parent pwd
	# dont show parameters when indexing arrays
	zstyle ':completion:*:*:-subscript-:*' tag-order indexes
	# Ignore backup files for commands
	zstyle ':completion:*:complete:-command-::commands' ignored-patterns='*\~'
	# disable usings hosts file because its huge
	zstyle ':completion:*' hosts off
	#}
	#{ Cache
	zstyle ':completion:*' use-cache on
	zstyle ':completion:*:complete:*' cache-path "$HOME/.zsh/cache"
	#}

	autoload -Uz compinit
	compinit

	compdef _gnu_generic zenity
	compdef wwwsave=wget
	compdef wwwsave=wget
	compdef '_files -g "*.swf"' flashplayer
fi
#}
#{ KeyBinds
if is zsh
then
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
	autoload zkbd
	function zkbd_file {
		[[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
		[[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
		return 1
	}
	mkdir -p ~/.zkbd
	keyfile=$(zkbd_file)
	if [[ $? == 1 ]]
	then
		zkbd
		keyfile=$(zkbd_file)
	fi
	if [[ $? == 0 ]]
	then source "$keyfile"
	else printf 'Failed to setup keys using zkbd.\n'
	fi
	unset zkbd_file
	unset keyfile
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
	#{ run-help
	bindkey -v "h" run-help
	#}
fi
#}
#{ Aliases
## allows aliases to be passed into sudo.
alias sudo="sudo "
#{ safety
alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"
#}
#{ Use color
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
#}
#{ human readable
alias df='df -h'
alias du='du -h'
alias wget='wget -q --show-progress'
#}
#{ ls
ls_common=(--color=auto --human-readable)
alias ls="ls -B ${ls_common[*]}"
alias ll="ls -l ${ls_common[*]}"
alias la="ls -A ${ls_common[*]}"
unset ls_common
#}
#{ git
for i in status commit merge pull push fetch grep log diff mv rm blame add
do alias g$i="git $i"
done; unset i
##}
#{ timew
alias start="timew start"
alias stop="timew stop"
alias cont="timew continue"
#}
#{ cpu settings
alias cpumin="sudo cpupower frequency-set -u 800MHz"
alias cpumed="sudo cpupower frequency-set -u 1.60GHz"
alias cpumax="sudo cpupower frequency-set -u 2.53GHz"
#}
#{ cmd | uploader
alias ix="curl -F 'f:1=<-' ix.io"
alias sprunge.us="curl -F 'sprunge=<-' http://sprunge.us"
#}
#{ readline wrappers
alias dc="rlwrap dc"
alias racket="rlwrap racket"
#}
#{ Locale Aliases
alias JP='LANG="ja_JP.UTF8" '
#}
#{ misc
alias hl='highlight -O ansi'
alias mnt='udisksctl mount -b'
alias unmnt='udisksctl unmount -b'
alias bget="wget --header='User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:36.0) Gecko/20100101 Firefox/36.0' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Accept-Language: en,ja;q=0.7,en-US;q=0.3' --header='Content-Type: application/x-www-form-urlencoded'"
#}
#{ Suffix Alias
if is zsh
then
	alias -s {png,jpg,jpeg,gif}=feh
	alias -s {3gp,avi,mkv,mp4,webm}=mpv
	alias -s {pdf,epub}=mupdf
	alias -s exe=wine
fi #}
#}
#{ Functions
#{ Timew tracking function
function track() {
	local tags=()
	while [[ "$1" = @* ]]
	do tags+=("${1/@/}"); shift
	done
	if ! hash "${1:?Requires a function to call}" &> /dev/null && [ -d "$1" -o ! -x "$1" ]
	then echo "Requires a valid function to call" >&2; return 1
	fi
	timew start "${tags[@]:-$(basename $1)}"
	"$@"
	timew stop
}
#}
#{ Tmux
function tat() { tmux new-session -As "${@:-$(basename $PWD)}"; }
function tdt() { tmux detach; }
function tsplit() { tmux split-window "$@"; }
#}
#{ neat curl things
function wttr {
	curl "wttr.in/$*"
}
function cheat.sh {
	curl "cheat.sh/$*"
}
#}

function hless() {
	highlight -Oansi "$@" | less -R
}

function lensay() {
	local ponycmd=()
	if [[ "$TERM" =~ 256color ]]
	then ponycmd+=(ponythink --bubble=think --file="$HOME/.local/share/catsay/len.cat")
	else ponycmd+=(ponysay   --bubble=linux --file="$HOME/.local/share/catsay/nul.cat")
	fi
	ponycmd+=(--wrap=i)
	"${ponycmd[@]}" "$@"
}

function mkcd() {
	mkdir -p "$*"; cd "$*" || exit
}
is zsh compdef mkcd=mkdir

# fuzzy cd lookup
hash fzf 2>/dev/null &&
	function fzcd() {
		local dir
		dir=$(find "${1:-.}" -path '*/\.*' -prune \
			-o -type d -print 2> /dev/null | fzf +m) &&
		cd $dir
	} &&
	is zsh compdef fzcd=cd

function tmpcd() {
	cd $(mktemp -d)
}
if is zsh
then
	unalias run-help &> /dev/null
	autoload run-help
fi

#}
if is zsh
then unfunction is
else unset is
fi
# vim: foldmarker=#{,#} foldmethod=marker filetype=zsh
