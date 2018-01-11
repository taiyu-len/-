function mkcd {
	mkdir -p "$*"
	cd "$*" || exit
}
compdef mkcd=mkdir

function tmpcd {
	cd $(mktemp -d)
}

function track {
	local tags=()
	while [[ "$1" = @* ]]
	do tags+="${1/@/}"; shift
	done
	if ! hash ${1:?Requires at least one function to call} &>/dev/null
	then echo "Requires a valid function to call" >&2; return 1
	fi
	timew start "${tags:-$(basename $1)}"
	"$@"
	timew stop
}

function tat {
	tmux new-session -As "${@:-$(basename $PWD)}"
}
function tsplit {
	tmux split-window "$@"
}

function cheat.sh {
	curl "cheat.sh/$*"
}

# run-help for builtins
unalias run-help &> /dev/null
autoload run-help
