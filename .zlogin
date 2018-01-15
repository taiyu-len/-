#{ message
daily_message $[$(tput cols) - 6] |
	if [[ "$TERM" = *256color ]]
	then lensay
	else lensay <(printf '$balloon$')
	fi
#}
# vim: foldmarker=#{,#} foldmethod=marker

