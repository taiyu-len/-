#{ Exports
function myterm() { #{
	urxvtc "$@"
	if [ $? -eq 2 ]
	then
		urxvtd -q -o -f
		urxvtc "$@"
	fi
} #}
export PAGE=less
export LESS=-iFXrRS
export EDITOR=vim
export TERMINAL=myterm
export BROWSER=palemoon
#{ Less termcap
export LESS_TERMCAP_mb=$(tput blink;tput setaf 11) # Begin Blinking in yellow
export LESS_TERMCAP_md=$(tput bold; tput setaf 9)  # Begin bold in red
export LESS_TERMCAP_us=$(tput smul; tput setaf 4)  # Begin underline in blue
export LESS_TERMCAP_ue=$(tput rmul; tput op)       # End underline
export LESS_TERMCAP_me=$(tput sgr0)                # Turn off bold, blink, underline
export LESS_TERMCAP_so=$(tput smso)                # Begin standout
export LESS_TERMCAP_se=$(tput rmso)                # End standout
#}
#}
#{ Alias
#{ LS Alias
alias ls="ls --color=auto"
alias ll="ls --color=auto -l"
alias la="ls --color=auto -a"
#}
#{ Interactive
alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"
#}
#{ Timew shortcuts
alias start="timew start"
alias stop="timew stop"
alias cont="timew continue"
#}
#{ language setting
alias JP='LANG="ja_JP.UTF8"'
#}
#{ uploaders. (cmd | ix)
alias ix="curl -F 'f:1=<-' ix.io"
alias sprunge.us="curl -F 'sprunge=<-' http://sprunge.us"
#}
#{ Shortcuts
alias cpumin="sudo cpupower frequency-set -u 800MHz"
alias cpumed="sudo cpupower frequency-set -u 1.60GHz"
alias cpumax="sudo cpupower frequency-set -u 2.53GHz"
alias hl='highlight -O ansi'
alias mnt='udisksctl mount -b'
alias unmnt='udisksctl unmount -b'
alias lensay='ponysay -flen -bthink -W120 --'
alias bget="wget --header='User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:36.0) Gecko/20100101 Firefox/36.0' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Accept-Language: en,ja;q=0.7,en-US;q=0.3' --header='Content-Type: application/x-www-form-urlencoded'"
#}
#{ RLWRAP aliases
alias dc="rlwrap dc"
alias racket="rlwrap racket"
#}
#}
# vim: foldmarker=#{,#} foldmethod=marker
