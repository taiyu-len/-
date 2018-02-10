#!/usr/bin/env bash
#{{{ Setup
hc() { herbstclient "$@" ;}
monitor=${1:-0}
geometry=( $(hc monitor_rect "$monitor") )
if [ -z "${geometry[*]}" ]; then
	echo "Invalid monitor $monitor"
	exit 1
fi
x=${geometry[0]}
y=${geometry[1]}
w=${geometry[2]}
h=16

#font="-xos4-terminus-medium-r-normal-*-12-140-72-72-c-80-iso10646-1"
font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
#font="-gnu-unifont-*-*-*-*-*-*-*-*-*-*-*-*"

# panel: default color for panel elements.
# focus: color for currently focused elements
# other: color for focused elements on other monitors
# alert: color for urgent tags
defaultbg=$(hc get frame_border_normal_color)
defaultfg="#cccccc"
panelbg="^bg()"
focusbg="^bg($(hc get window_border_active_color))"
otherbg="^bg($(hc get window_border_normal_color))"
alertbg="^bg($(hc get window_border_urgent_color))"
panelfg="^fg()"
focusfg="^fg(#ffffff)"
otherfg="^fg(#aaaaaa)"
alertfg="^fg(#000000)"

#{{{ Textwidth function
if hash textwidth &> /dev/null ; then
	textwidth="textwidth";
elif hash dzen2-textwidth &> /dev/null ; then
	textwidth="dzen2-textwidth";
else
	echo "This script requires the textwidth tool of the dzen2 project."
	exit 1
fi
#}}}
#{{{ dzen2 function
# true if we are using the svn version of dzen2
# depending on version/distribution, this seems to have version strings like
# "dzen-" or "dzen-x.x.x-svn"
if dzen2 -v 2>&1 | head -n 1 | grep -q '^dzen-\([^,]*-svn\|\),'; then
	dzen2_svn="true"
else
	dzen2_svn=""
fi
#}}}
#{{{ uniq function
uniq=(awk)
if awk -Wv 2>/dev/null | head -1 | grep -q '^mawk'; then
    # mawk needs "-W interactive" to line-buffer stdout correctly
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593504
    uniq+=(-W interactive)
fi
uniq+=('$0 != l { print ; l=$0 ; fflush(); }')
#}}}
#}}}
#{{{ Event Generator function.
# based on different input data (mpc, date, hlwm hooks, ...)
# this generates events, formed like this:
#     <eventname>\t<data> [...]
# e.g.
#     date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29
event_generator() {
	unset pids
	date_generator() {
		printf "date\t$focusfg%(%H:%M$otherfg, %Y-%m-$focusfg%d%)T\n"
		sleep $((60 - $(printf "%(%S)T")))
	}
	ipaddr_generator() {
		ip -br addr | awk '
		BEGIN { printf "ipaddr\t" }
		$2 == "UP" {
			printf "'$focusfg'" $1 ":^fg(#99ef99)" substr($3, 0, index($3, "/")-1)
		}
		END { print "" }'
		sleep 20s
	}
	add_job() {
		while :; do "$@"
		done > >(exec "${uniq[@]}")&
		pids+=($!)
	}
	add_job date_generator
	add_job ipaddr_generator

	hc --idle
	kill "${pids[@]}"
}
#}}}
#{{{ initialize eventloop data
update_tags() {
	IFS=$'\t' read -ra tags <<< "$(hc tag_status "$monitor")"
}
event_init() {
	update_tags
	visible=true
	date=
	ipaddr=
	windowtitle=
	separator=" $focusfg| "
}
#}}}
#{{{ handle event and set event data
handle_event() {
	cmd=("$@")
	case "${cmd[0]}" in
	focus_changed|window_title_changed) windowtitle="${cmd[*]:2}" ;;
	date) date="${cmd[*]:1}" ;;
	ipaddr) ipaddr="${cmd[*]:1}" ;;
	tag*) update_tags ;;
	quit_panel|reload) exit ;;
	togglehidepanel) #{{{
		if [ "${cmd[1]}" -ne "$monitor" ] ; then
			return
		fi
		currentidx=$(hc attr monitors.focus.index)
		if [ "${cmd[1]}" = "current" ] && [ "$currentidx" -ne "$monitor" ] ; then
			return
		fi
		echo "^togglehide()"
		if "$visible" ; then
			visible=false
			hc pad "$monitor" 0
		else
			visible=true
			hc pad "$monitor" "$h"
		fi
		;; #}}}
	esac
}
#}}}
#{{{ event consumer
event_consumer() {
	# wait for first event and handle it.
	if IFS=$'\t' read -ra cmd ; then
		handle_event "${cmd[@]}"
		# read in more events until we timeout.
		while IFS=$'\t' read -t .1 -ra cmd ; do
			handle_event "${cmd[@]}"
		done
	else
		return 1
	fi
}
#}}}
#{{{ Panel Update
#{{{ Panel tags
if [ "$dzen2_svn" ] ; then
	_print_tag() {
		# clickable tags if using SVN dzen
		printf %s "^ca(1,herbstclient and "
		printf %s ", focus_monitor \"$monitor\" "
		printf %s ", use \"$1\") $1 ^ca()"
	}
else
	_print_tag() {
		printf "%s" " $1 "
	}
fi
print_tag() {
	case "${1:0:1}" in
	'#') printf "%s" "$focusbg$focusfg" ;;
	'+') printf "%s" "$otherbg$otherfg" ;;
	':') printf "%s" "$panelbg$panelfg" ;;
	'!') printf "%s" "$alertbg$alertfg" ;;
	# ignore empty tags, and tags on other monitors
	 * ) return ;;
	esac
	_print_tag "${1:1}"
	printf "%s" "$panelbg$panelfg"
}
#}}}
append_right() {
	for i in "$@"; do
		[ "$i" ] && right+="$separator$i"
	done
}
panel_update() {
	for i in "${tags[@]}" ; do
		print_tag "$i"
	done
	append_left "$separator"
	printf "%s" "$separator"
	printf "%s" "$panelbg$panelfg ${windowtitle//^/^^}"
	right=
	append_right "$player"
	append_right "$ipaddr"
	append_right "$date"
	# filter out ^(stuff) and get an estimated text width.
	right_text_only=$(echo -n "$right" | sed 's/\^[^(]*([^)]*)//g' )
	right_width=$($textwidth "$font" "$right_text_only    ")
	printf "%s" "^pa($((w - right_width)))$right"
	# print panel
	echo
}
#}}}
#{{{ Execute
dzen2_opts=(-fn "$font")
dzen2_opts+=(-w "$w")
dzen2_opts+=(-h "$h")
dzen2_opts+=(-x "$x")
dzen2_opts+=(-y "$y")
scrollcmd() { printf "%s" "exec:herbstclient use_index $1 --skip-visible" ;}
dzen2_opts+=(-e "button4=$(scrollcmd -1);button5=$(scrollcmd +1)")
dzen2_opts+=(-ta l)
dzen2_opts+=(-bg "$defaultbg")
dzen2_opts+=(-fg "$defaultfg")

hc pad "$monitor" "$h"
event_generator  2>/dev/null | {
	event_init
	while true ; do
		panel_update
		event_consumer
	done
} 2>/dev/null | dzen2 "${dzen2_opts[@]}"
hc pad "$monitor" 0
# vim: foldmarker={{{,}}} foldmethod=marker
