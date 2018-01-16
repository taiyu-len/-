#{ Global Exports
# export LS_COLORS
eval $(dircolors ~/.dircolors)
#{ Less
export LESS=-irRS~
export LESSSECURE=1
export LESS_TERMCAP_mb=$(tput blink;tput setaf 11) # Begin Blinking in yellow
export LESS_TERMCAP_md=$(tput bold; tput setaf 9)  # Begin bold in red
export LESS_TERMCAP_us=$(tput smul; tput setaf 4)  # Begin underline in blue
export LESS_TERMCAP_ue=$(tput rmul; tput op)       # End underline
export LESS_TERMCAP_me=$(tput sgr0)                # Turn off bold, blink, underline
export LESS_TERMCAP_so=$(tput smso)                # Begin standout
export LESS_TERMCAP_se=$(tput rmso)                # End standout
export PAGER=less
export MANPAGER="less -iXF"
#}
export GCC_COLORS="warning=01;33" # use yellow warning
export EDITOR=vim
export BROWSER=w3m
export TERMINAL=start-urxvtc

# Set language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# add local bin to path
export PATH="$HOME/.local/bin":"$PATH"
#}
# vim: foldmarker=#{,#} foldmethod=marker
