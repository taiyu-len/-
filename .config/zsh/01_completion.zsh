# Auto Completion Configuration
###############################

zstyle ':completion:*' completer _extensions _complete _match _prefix _ignored _correct _approximate
zstyle ':completion:*' menu select # better selection
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # use same colors as ls command
zstyle ':completion:*' group-name '' #group options by description

zstyle ':completion:*:descriptions' format '%F{7}%U%B== %d ==%b%u%f'
zstyle ':completion:*:messages' format '%F{7}$U%d$u%f'
zstyle ':completion:*:warnings' format '%Bno matches for: %d%b'

zstyle ':completion:*' use-cache on # enable completion cache
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"

zstyle ':completion:*' hosts off

zstyle ':completion:*:cd:*' ignore-parents parent pwd


autoload -Uz compinit
compinit

compdef _gnu_generic zenity

