function myterm {
	urxvtc "$@"
	if [ $? -eq 2 ]
	then
		urxvtd -q -o -f
		urxvtc "$@"
	fi
}

export PAGE=less
export LESS=-iFXrRS
export EDITOR=vim
export TERMINAL=myterm
export BROWSER=palemoon

# Less termcap
export LESS_TERMCAP_mb=$(tput blink;tput setaf 11) # Begin Blinking in yellow
export LESS_TERMCAP_md=$(tput bold; tput setaf 9)  # Begin bold in red
export LESS_TERMCAP_us=$(tput smul; tput setaf 4)  # Begin underline in blue
export LESS_TERMCAP_ue=$(tput rmul; tput op)       # End underline
export LESS_TERMCAP_me=$(tput sgr0)                # Turn off bold, blink, underline
export LESS_TERMCAP_so=$(tput smso)                # Begin standout
export LESS_TERMCAP_se=$(tput rmso)                # End standout

