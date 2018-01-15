#{ Global Exports
# export LS_COLORS
eval $(dircolors ~/.dircolors)
export PAGER=less
export MANPAGER="less -iXF"
export LESS=-irRS~
export LESSSECURE=1
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
