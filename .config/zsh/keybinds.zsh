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
#{{{ Fix special keys
typeset -A key
autoload zkbd
zkbd_file() {
	{ test -f "$ZDOTDIR/zkbd/${TERM}-${VENDOR}-${OSTYPE}" && printf "%s" "$_" ;} ||
	{ test -f "$ZDOTDIR/zkbd/${TERM}-${DISPLAY}"          && printf "%s" "$_" ;} ||
	{ test -f "$ZDOTDIR/zkbd/${TERM}"                     && printf "%s" "$_" ;}
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

