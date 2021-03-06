# Startup order
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
if test "$BASH"
then
	set -o noclobber
	HISTCONTROL=ignoreboth
	HISTTIMEFORMAT=%s
	HISTFILE=~/.bash_history
	PS1='\$ '
fi
WORDCHARS='[:alnum:]'
#{{{ Aliases
## Command aliases
alias sudo="sudo "
alias torify="torify "
alias exec="exec "
alias command="command "
#{{{ pkill
alias pstop="pkill -STOP"
alias pcont="pkill -CONT"
#}}}
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
#{{{ Replacements
alias rename=perl-rename
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
alias cpuinfo="cpupower frequency-info"
#}}}
#{{{ cmd | uploader
alias ix="curl -F 'f:1=<-' ix.io"
alias myix="curl --netrc-file=~/.netrc.ix.io  -nF 'f:1=<-' ix.io"
alias sprunge.us="curl -F 'sprunge=<-' http://sprunge.us"
#}}}
#{{{ readline wrappers
alias dc="rlwrap dc"
#}}}
#{{{ Locale Aliases
alias JP='LANG="ja_JP.UTF8" LC_ALL="ja_JP.UTF8" '
#}}}
#{{{ misc
alias zathura="zathura --fork --log-level=error"
alias info="info --vi-keys"
alias hl='highlight -O ansi'
alias mnt='udisksctl mount -b'
alias unmnt='udisksctl unmount -b'
alias bget="wget --header='User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:36.0) Gecko/20100101 Firefox/36.0' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Accept-Language: en,ja;q=0.7,en-US;q=0.3' --header='Content-Type: application/x-www-form-urlencoded'"
alias hc="herbstclient"
alias img2clip="xclip -selection clipboard -target image/png -i"
alias garyc="surf https://garyc.me/sketch/"
#}}}
#}}}
#{{{ GPG
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
#}}}
#{{{ Functions
#{{{ Tmux
tat() { tmux new-session -As "${@:-$(basename "$PWD")}"; }
tdt() { tmux detach; }
ts() {
	[ $# -eq 1 ] && set -- bash -ic "$@"
	tmux split-window -vp 33 "$@"
}
tv() {
	[ $# -eq 1 ] && set -- bash -ic "$@"
	tmux split-window -hp 33 "$@"
}
alias ts="ts "
alias tv="tv "
#}}}
#{{{ Task
timelock() {
	timew start "${@-locked}"
	slock
	timew stop "${@-locked}"
}
tasklock() {
	local first="${1:0:1}"
	local uuid="$(task status:pending "${1#-}" uuids)"
	shift
	if task "$uuid" start "$@"
	then
		slock
		if [ "$first" = "-"  ]
		then task "$uuid" done
		else task "$uuid" stop
		fi
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
	local prev=
	local cur=
	if test -v 1; then local selection="-selection"; fi
	while ! read -t 0.1
	do
		cur="$(xclip -o $selection $1 2> /dev/null)"
		if test "$cur" != "$prev"
		then prev="$cur"; printf "%s\n" "$cur";
		fi
	done
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
hless() { highlight -Oansi "$@" | less -R ;}
sleep_until() {
	local d="$(date -d "$*" +%s)" || return 1
	sleep $[d - $(date +%s)]
}
alarm() {
	date +%T;  date -d "$*" +%T; sleep_until "$*"
	beep -d50 -nr5 -nr5 -nr5 -nr5 -nr5
	while pgrep slock >/dev/null
	do beep -d50 -r4 && sleep 5m || sleep 1
	done
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
cd() {
	if [[ $# -eq 1 ]] && [[ -f "$1" ]]; then
		local dir="$(dirname "$1")"
		[[ ! -e "$dir" ]] && return 1
		echo "Correcting $1 to $dir"
		builtin cd "$dir"
	else
		builtin cd "$@"
	fi
}
cl() {
	cd $1 && ls
}
mkcd() {
	if [[ "$#" -ne 1 ]]
	then printf 'usage: mkcd <new-directory>\n'; return 1;
	fi
	if [[ ! -d "$1" ]]
	then \command mkdir -p "$1"
	else printf '`%s'\'' already exists: cd-ing.\n' "$1"
	fi
	builtin cd "$1"
}

tmpcd() {
	builtin cd "$(mktemp -d)"
	builtin pwd
}
#}}}
#}}}
# vim: foldmethod=marker foldmarker={{{,}}}
