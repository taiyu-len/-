## KeyBinds ##
# Map Ctrl-Z to call fg, prefering to resume vim if it exist
# via http://git.grml.org/?p=grml-etc-core.git;a=blob_plain;f=etc/zsh/zshrc;hb=HEAD
function grml-zsh-fg() {
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

autoload -Uz bracketed-paste-url-magic
#zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-url-magic

# ..... => ../../../..
function rationalise-dot {
	if [[ $LBUFFER = *.. ]]
	then LBUFFER+=/..
	else LBUFFER+=.
	fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# Fix special characters
typeset -A key
function {
	autoload zkbd
	function zkbd_file {
		[[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
		[[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
		return 1
	}

	mkdir -p ~/.zkbd
	local keyfile=$(zkbd_file)
	if [[ $? == 1 ]]
	then
		zkbd
		keyfile=$(zkbd_file)
	fi
	if [[ $? == 0 ]]
	then source "${keyfile}"
	else printf 'Failed to setup keys using zkbd.\n'
	fi
	unfunction zkbd_file
}
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



