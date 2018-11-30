# : completion : function : completer : command : argument : tag
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
zstyle ':completion:*:mkdir:*' ignore-parents parent pwd
# dont show parameters when indexing arrays
zstyle ':completion:*:*:-subscript-:*' tag-order indexes
# Ignore backup files for commands
zstyle ':completion:*:complete:-command-::commands' ignored-patterns='*\~'
# disable usings hosts file because its huge
zstyle ':completion:*' hosts off
#}}}
#{{{ Cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
#}}}
fpath+=("$HOME/.local/share/zsh/functions/Completion/Zsh")

autoload -Uz compinit
compinit

# My programs/aliass/functions
compdef wwwsave=wget
compdef wwwmirror=wget
compdef '_files -g "*.swf"' flashplayer
compdef spawn=command
compdef ts=command
compdef tv=command
compdef mkcd=mkdir
compdef fzcd=cd

compdef _gnu_generic fdupes

unalias run-help &> /dev/null
autoload run-help
