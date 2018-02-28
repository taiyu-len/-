#{{{ Global Exports
#{{{ paths and programs
export PATH=~/.local/bin:"$PATH"
export EDITOR=vim
export GIT_EDITOR=vi
export BROWSER=w3m
export TERMINAL=start-urxvtc
export MAIL=~/.mail
export MAILCHECK=$[60*15]
export SXHKD_SHELL=sh
export RLWRAP_HOME=~/.rlwrap
#}}}
#{{{ Files
export ZSHRC=~/.zshrc
export BASHRC=~/.bashrc
export VIMRC=~/.vim/vimrc
#}}}
#{{{ Colors
eval $(dircolors ~/.dircolors)
export GCC_COLORS="warning=01;33" # use yellow warning
export S_COLORS=auto
#{{{ Less
export LESS=-irRS~
export LESSSECURE=1
export LESS_TERMCAP_mb=$(tput blink; tput setaf 3)   # Begin Blinking in yellow
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)    # Begin bold in red
export LESS_TERMCAP_us=$(tput smul; tput setaf 6)    # Begin underline in cyan
export LESS_TERMCAP_ue=$(tput rmul; tput op)         # End underline
export LESS_TERMCAP_me=$(tput sgr0)                  # Turn off bold, blink, underline
export LESS_TERMCAP_so=$(tput setaf 2; tput setab 0) # Begin standout
export LESS_TERMCAP_se=$(tput sgr0)                  # End standout
export PAGER=less
export MANPAGER="less -iXF"
#}}}
#}}}
#{{{ Set language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
#}}}
# vim: foldmethod=marker
