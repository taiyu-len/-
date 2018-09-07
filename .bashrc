#{{{ Startup Order
#{{{ Bash
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
#}}}
#{{{ Zsh
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
#}}}
#}}}
#{{{ Shell test
if   [[ "$0" =~ zsh ]] && [ "$ZSH_NAME" ]
then is() { [ "$1" = zsh  ] && shift && "$@" ;}
elif [ "$BASH" ]
then is() { [ "$1" = bash ] && shift && "$@" ;}
else is() { false; }
fi
#}}}
#{{{ Options
if is zsh #{{{
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
	setopt NO_CLOBBER

	setopt AUTOCD # type directory name to change to it
	setopt EXTENDEDGLOB # regular expresssion globbing
	#}}}
elif is bash #{{{
then
	set -o noclobber
fi #}}}
#}}}
#{{{ History
ign_cmds=(ls cd "cd -" pwd exit date "* --help" "* -h" jobs fg bg htop ps "* /tmp*")
HISTSIZE=1000000
HISTFILE=
if is zsh #{{{
then
	# Infinite history size,
	# enables start, end meta data.
	# use shared history between ttys
	HISTFILE=~/.zsh/history
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
	#}}}
elif is bash #{{{
then
	HISTIGNORE="$(IFS=:; printf %s "${ign_cmds[*]}")"
	HISTCONTROL=ignoreboth
	HISTTIMEFORMAT=%s
	HISTFILE=~/.bash_history
fi #}}}
unset ign_cmds
#}}}
#{{{ Prompt
if is zsh #{{{
then
	[[ $TERM =~ (screen|rxvt) ]]
	ZLE_RPROMPT_INDENT=$?
	setopt PROMPT_SUBST
	my_git_status() { #{{{
		emulate -L zsh
		local b c s # branch_name, has changes to be commited, status of uncommited files
		typeset -A s
		{
			local line
			read -r line && b=$(sed -n 's/^## \(\(.*\)\.\.\..*\|\(.*\)\)/\2\3/;T;p' <<< "$line")
			[ "$b" ] && while IFS= read -r line; do
				[[ ! "${line:0:1}" =~ [?!\ ] ]] && c=+
				[[ "${line:0:1}" == 'A' ]] && ((++s[A]))
				((++s[${line:1:1}]))
			done
		} < <(git status -bs --porcelain=v1 2>/dev/null)
		local B="%F{blu}" R="%F{r}" G="%F{g}"
		printf "%s" "${b:+│ $c$b ${s[M]:+$B$s[M] }${s[A]:+$G$s[A] }${s[D]:+$R$s[D] }}"
	} #}}}
	PS_PREFIX='%B%K{black}%F{white}' PS_SUFFIX='%f%k%b'
	PS1="$PS_PREFIX%(1j.%j.)│$PS_SUFFIX "
	RPS1="$PS_PREFIX"' %~ $(my_git_status)'"$PS_SUFFIX"
	[[ "$TERM" == "linux" ]] && PS1+=' '
	PS2="$PS_PREFIX%_ │$PS_SUFFIX "
	PS3="$PS_PREFIX?# │$PS_SUFFIX "
	#}}}
elif is bash #{{{
then PS1='\$ '
fi #}}}
#}}}
#{{{ Completions
if is zsh
then
	test -e ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh && . "$_"
	# : completion : function : completer : command : argument : tag
	#
	# Completers to use.
	#zstyle ':completion:*' completer _expand _extensions _complete _ignored _correct _approximate _files
	zstyle ':completion:*' completer _extensions _expand _prefix _complete _ignored _correct _approximate
	#{{{ Display
	# Use colors for results
	zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # enable colors
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
	#}}}
	#{{{ Selection
	# Use menu by default
	zstyle ':completion:*'       menu select
	# use first menu choice right away
	zstyle ':completion:*:man:*' menu yes select
	#}}}
	#{{{ Generating
	# lowercase matches uppercase. aka smartcase
	zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
	# allow to match all or a matching file
	zstyle ':completion:*:expand:*' tag-order 'all-expansions expansions'
	# on processes completion complete all user processes
	zstyle ':completion:*:processes' command 'ps -a'
	#}}}
	#{{{ Corrections
	# allow 1 error per 3 characters
	zstyle -e ':completion:*:approximate:' max-errors 'reply=($(((3+$#PREFIX+$#SUFFIX)/3)) numeric)'
	zstyle    ':completion:*:expand:' keep-prefix true
	# ignore functions starting with _ when approximate matching
	zstyle  ':completion:*:(^approximate*):*:functions' ignored-patterns '_*'
	#}}}
	#{{{ Filtering
	# ignore cd ../$pwd
	zstyle ':completion:*:cd:*'   ignore-parents parent pwd
	zstyle ':completion:*:mkcd:*' ignore-parents parent pwd
	# dont show parameters when indexing arrays
	zstyle ':completion:*:*:-subscript-:*' tag-order indexes
	# Ignore backup files for commands
	zstyle ':completion:*:complete:-command-::commands' ignored-patterns='*\~'
	# disable usings hosts file because its huge
	zstyle ':completion:*' hosts off
	#}}}
	#{{{ Cache
	zstyle ':completion:*' use-cache on
	zstyle ':completion:*:complete:*' cache-path ~/.zsh/cache
	#}}}
	fpath+=("$HOME/.local/share/zsh/functions/Completion/Zsh")

	autoload -Uz compinit
	compinit

	compdef _gnu_generic zenity
	compdef wwwsave=wget
	compdef wwwsave=wget
	compdef '_files -g "*.swf"' flashplayer
fi
#}}}
#{{{ KeyBinds
if is zsh
then
	#{{{ Map Ctrl-Z to call fg
	# via http://git.grml.org/?p=grml-etc-core.git;a=blob_plain;f=etc/zsh/zshrc;hb=HEAD
	grml-zsh-fg() {
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
	#}}}
	#{{{ Fix pasted urls
	autoload -Uz bracketed-paste-url-magic
	zle -N bracketed-paste bracketed-paste-url-magic
	#}}}
	#{{{ .... => ../../..
	rationalise-dot() {
		if [[ $LBUFFER = *.. ]]
		then LBUFFER+=/..
		else LBUFFER+=.
		fi
	}
	zle -N rationalise-dot
	bindkey . rationalise-dot
	#}}}
	#{{{ Fix special characters
	typeset -A key
	autoload zkbd
	zkbd_file() {
		{ test -f ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && printf "%s" "$_" ;} ||
		{ test -f ~/".zkbd/${TERM}-${DISPLAY}"          && printf "%s" "$_" ;}
	}
	load_zkbd() { keyfile="$(zkbd_file)" && source "$keyfile" ;}
	if ! load_zkbd
	then zkbd && load_zkbd || printf 'Failed to setup keys via zkbd.\n' 1>&2
	fi
	unfunction zkbd_file load_zkbd
	unset keyfile
	#}}}
	#{{{ set mappings
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
	#}}}
	#{{{ run-help
	bindkey -v "h" run-help
	#}}}
fi
#}}}
#{{{ Aliases
## Command aliases
alias sudo="sudo "
alias torify="torify "
alias exec="exec "
alias command="command "
#{{{ Config
alias config="/usr/bin/git --git-dir=$HOME/.home.git/ --work-tree=$HOME"
#}}}
#{{{ safety
alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i --one-file-system"
#}}}
#{{{ Use color
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -c'
#}}}
#{{{ human readable
alias df='df -h'
alias du='du -h'
alias wget='wget -q --show-progress'
#}}}
#{{{ ls
ls_common=(--color=auto --human-readable)
alias ls="\\ls -B ${ls_common[*]}"
alias ll="\\ls -l ${ls_common[*]}"
alias la="\\ls -A ${ls_common[*]}"
unset ls_common
#}}}
#{{{ timew
alias start="timew start"
alias stop="timew stop"
alias cont="timew continue"
#}}}
#{{{ nq
alias nq="nq "
mkdir -p /tmp/.nq-wget
alias qget='NQDIR=/tmp/nq-wget \nq \wget --progress=dot:mega'
alias fget='NQDIR=/tmp/nq-wget \fq'
#}}}
#{{{ cpu settings
alias cpumin="sudo cpupower frequency-set -u 800MHz"
alias cpumed="sudo cpupower frequency-set -u 1.60GHz"
alias cpumax="sudo cpupower frequency-set -u 2.53GHz"
#}}}
#{{{ cmd | uploader
alias ix="curl -F 'f:1=<-' ix.io"
alias myix="curl -nF 'f:1=<-' ix.io"
alias sprunge.us="curl -F 'sprunge=<-' http://sprunge.us"
#}}}
#{{{ readline wrappers
alias dc="rlwrap dc"
alias racket="rlwrap racket"
#}}}
#{{{ Locale Aliases
alias JP='LANG="ja_JP.UTF8" LC_ALL="ja_JP.UTF8" '
#}}}
#{{{ misc
alias info="info --vi-keys"
alias hl='highlight -O ansi'
alias mnt='udisksctl mount -b'
alias unmnt='udisksctl unmount -b'
alias bget="wget --header='User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:36.0) Gecko/20100101 Firefox/36.0' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Accept-Language: en,ja;q=0.7,en-US;q=0.3' --header='Content-Type: application/x-www-form-urlencoded'"
alias hc="herbstclient"
#}}}
#{{{ Suffix Alias
if is zsh
then
	alias -s {png,jpg,jpeg,gif}=feh
	alias -s {3gp,avi,mkv,mp4,webm}=mpv
	alias -s {pdf,epub}=mupdf
	alias -s exe=wine
fi #}}}
#}}}
#{{{ GPG
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
#}}}
#{{{ Functions
#{{{ Tmux
tat() { tmux new-session -As "${@:-$(basename "$PWD")}"; }
tdt() { tmux detach; }
tsplit() { tmux split-window "$@"; }
#}}}
#{{{ Task
timelock() {
	timew start "${@-locked}"
	slock
	timew stop "${@-locked}"
}
tasklock() {
	task="$1"; shift
	task "${task#-}" start "$@"
	slock
	if [ "${task:0:1}" = "-"  ]
	then task "${task#-}" done
	else task "${task#-}" stop
	fi
}
track() {
	local tags=()
	while [[ "$1" = @* ]]
	do tags+=("${1/@/}"); shift
	done
	if ! hash "${1:?Requires a function to call}" &> /dev/null && { [ -d "$1" ] || [ ! -x "$1" ]; }
	then echo "Requires a valid function to call" >&2; return 1
	fi
	timew start "${tags[@]:-$(basename "$1")}"
	"$@"
	timew stop
}
#}}}
#{{{ neat curl things
wttr() { curl "wttr.in/$*" ;}
cheat.sh() { curl "cheat.sh/$*" ;}
#}}}
xclip_loop() {
	while ! read -t "${1:-1}"
	do xclip -o; echo
	done | awk '$0 != last && $0 != "" { last=$0; print; fflush(); }'
}
# Parallel implementation
plll() {
	local line
	while read line
	do
		local args=("$line")
		while read -t 1 line
		do args+=("$line")
		done
		"$@" "${args[@]}"
	done
}

spawn() { ("$@" </dev/null &>/dev/null &) ;}
is zsh compdef spawn=command
hless() { highlight -Oansi "$@" | less -R ;}
sleep_until() {
	d="$(date -d "$1" +%s)" || return 1
	sleep $[d - $(date +%s)]
}
lensay() {
	local ponycmd=()
	if [[ "$TERM" =~ 256color ]]
	then ponycmd+=(ponythink --bubble think --file ~/.local/share/catsay/len.cat)
	else ponycmd+=(ponysay   --bubble linux --file ~/.local/share/catsay/nul.cat)
	fi
	ponycmd+=(--wrap=i)
	"${ponycmd[@]}" "$@"
}
#{{{ *cd
mkcd() { mkdir -p "$*" &&  cd "$_" ;}
is zsh compdef mkcd=mkdir

# fuzzy cd lookup
hash fzf 2>/dev/null &&
	fzcd() {
		local dir
		dir=$(find "${1:-.}" -path '*/\.*' -prune \
			-o -type d -print 2> /dev/null | fzf +m) &&
		cd "$dir"
	} &&
	is zsh compdef fzcd=cd

tmpcd() {
	cd "$(mktemp -dp /tmp ${*:+-d "$*.XXXXXXXXX"})"
	pwd
}
#}}}
#{{{ help
if is zsh
then
	unalias run-help &> /dev/null
	autoload run-help
fi
#}}}
#}}}
#{{{ Cleanup
if is zsh
then unfunction is
else unset is
fi
#}}}
# vim: foldmethod=marker foldmarker={{{,}}} filetype=zsh
