#!/usr/bin/env bash
#{{{ Setup
hc() { herbstclient "$@" ;}
monitor=${1:-0}
geometry=( $(hc monitor_rect "$monitor") )
if [ -z "${geometry[*]}" ]
then
	echo "Invalid monitor $monitor"
	exit 1
fi
# geometry=(X Y W H)
w=${geometry[2]}
h=10
x=${geometry[0]}
y=${geometry[1]}                       # top
#y=$((geometry[1] + geometry[3] - h))  # bottom

#font="-xos4-terminus-medium-r-normal-*-12-140-72-72-c-80-iso10646-1"
#font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
font="-*-dina-medium-r-*-*-10-*-*-*-*-*-*-*"

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
separator="$focusfg|"

#{{{ Textwidth function
if hash textwidth >/dev/null 2>&1
then textwidth="textwidth";
elif hash dzen2-textwidth >/dev/null 2>&1
then textwidth="dzen2-textwidth";
else
	echo "This script requires the textwidth tool of the dzen2 project."
	exit 1
fi
#}}}
#{{{ dzen2 function
# true if we are using the svn version of dzen2
# depending on version/distribution, this seems to have version strings like
# "dzen-" or "dzen-x.x.x-svn"
if dzen2 -v 2>&1 | head -n 1 | grep -q '^dzen-\([^,]*-svn\|\),'
then dzen2_svn="true"
else dzen2_svn=""
fi
#}}}
#{{{ uniq function
uniq=(awk)
# mawk needs "-W interactive" to line-buffer stdout correctly
# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593504
if awk -Wv 2>/dev/null | head -1 | grep -q '^mawk'
then uniq+=(-W interactive)
fi
uniq+=("\$0 != l { print ; l=\$0 ; fflush(); }")
#}}}
#}}}
#{{{ Event Generator function.
# Generate events in the form
# $eventname\t$eventdata...
event_generator() {
	# Add jobs into pids in order to kill processes.
	# long running jobs
	local pids=()
	add_job() {
		while :
		do "$@"; sleep 1
		done > >(exec "${uniq[@]}") &
		pids+=($!)
	}
	header() { printf "%s\\t%s" "$1" "${2:-$panelbg} " ;}
	date_generator() {
		printf "$(header date)$focusfg%(%H:%M$otherfg|%Y-$panelfg%m-$focusfg%d)T\\n"
		sleep $((60 - $(printf "%(%S)T")))
	}
	ipaddr_generator() {
		ip -br addr | awk -v hdr="$(header ipaddr)" -v fg="$focusfg" '
		BEGIN { printf hdr }
		$2 == "UP" {
			printf fg $1 ":^fg(#99ef99)" substr($3, 0, index($3, "/")-1)
		}
		END { print "" }'
		sleep 30
	}
	load_generator() {
		</proc/loadavg awk -v h="$(header load)$focusfg" -v f1="$panelfg" -v f2="$otherfg" '{
			print h $1, f1 $2, f2  $3
		}'
		sleep 5
	}
	mem_generator() {
		free -hs5 > >(exec awk -v h1="$(header mem)" -v h2="$(header swap)" \
			-v f1="$panelfg" -v f2="$focusfg" -v f3="$otherfg" '
			$1 == "Mem:" && $3 != mem {
				mem = $3;
				print h1 f1 "M:" f2 $3 f3 "/" $2;
				fflush()
			}
			$1 == "Swap:" && $3 != swp && $3 != "0B" {
				swp = $3;
				print h2 f1 "S:" f2 $3 f3 "/" $2;
				fflush()
			}') & pids+=($!)
	}
	add_job date_generator
	add_job ipaddr_generator
	add_job load_generator
	mem_generator

	hc --idle
	kill "${pids[@]}"
}
#}}}
#{{{ initialize eventloop data
#{{{ Panel tags
if [ "$dzen2_svn" ]
then
	print_tag() {
		# clickable tags if using SVN dzen
		printf %s "^ca(1,herbstclient and "
		printf %s ", focus_monitor \"$monitor\" "
		printf %s ", use \"$1\") $1 ^ca()"
	}
else
	print_tag() {
		printf "%s" " $1 "
	}
fi
format_tag() {
	case "${1:0:1}" in
	'#') printf "%s" "$focusbg$focusfg" ;;
	'+') printf "%s" "$otherbg$otherfg" ;;
	':') printf "%s" "$panelbg$panelfg" ;;
	'!') printf "%s" "$alertbg$alertfg" ;;
	# ignore empty tags, and tags on other monitors
	 * ) return ;;
	esac
	print_tag "${1:1}"
}
update_tags() {
	tags=
	while read -d $'\t' -r tag
	do tags+="$(format_tag "$tag")"
	done <<< "$(hc tag_status "$monitor")"
}
#}}}
event_init() {
	update_tags
	visible=true
	date=
	mem=
	swap=
	ipaddr=
	windowtitle=
}
#}}}
#{{{ handle event and set event data
handle_event() {
	cmd=("$@")
	case "${cmd[0]}" in
	focus_changed|window_title_changed) windowtitle="${cmd[*]:2}" ;;
	date  ) date="${cmd[*]:1}" ;;
	mem   ) mem="${cmd[*]:1}" ;;
	swap  ) swap="${cmd[*]:1}" ;;
	load  ) load="${cmd[*]:1}" ;;
	ipaddr) ipaddr="${cmd[*]:1}" ;;
	tag*|urgent) update_tags ;;
	quit_panel|reload) hc pad "$monitor" 0 && exit ;;
	togglehidepanel) #{{{
		[ "${cmd[1]}" -ne "$monitor" ] && return
		currentidx=$(hc attr monitors.focus.index)
		[ "${cmd[1]}" = "current" ] && [ "$currentidx" -ne "$monitor" ] && return
		echo "^togglehide()"
		if "$visible"
		then
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
	if IFS=$'\t' read -ra cmd
	then
		handle_event "${cmd[@]}"
		# read in more events until we timeout.
		while IFS=$'\t' read -t .05 -ra cmd
		do handle_event "${cmd[@]}"
		done
	else
		return 1
	fi
}
#}}}
#{{{ Panel Update
append_right() {
	for i
	do [ "$i" ] && right+=" $separator$i"
	done
}
panel_update() {
	printf "%s" "$tags$focusfg^r(1x$h)"
	printf "%s" "^ca(1,herbstclient focus_monitor \"$monitor\")"
	printf "%s" "$panelbg$panelfg ${windowtitle//^/^^}"
	right=
	append_right "$mem"
	append_right "$swap"
	append_right "$load"
	append_right "$player"
	append_right "$ipaddr"
	append_right "$date"
	# filter out ^(stuff) and get a poorly estimated text width.
	right_text_only=$(echo -n "$right" | sed 's/\^[^(]*([^)]*)//g')
	right_width=$($textwidth "$font" "$right_text_only")
	printf "%s" "^pa($((w - right_width)))$right"
	# print panel
	echo "^ca()"
}
#}}}
#{{{ Execute
dzen2_opts=(-fn "$font")
dzen2_opts+=(-w "$w")
dzen2_opts+=(-h "$h")
dzen2_opts+=(-x "$x")
dzen2_opts+=(-y "$y")
scrollcmd() {
	printf "%s" "exec:herbstclient and % focus_monitor $monitor % use_index $1 --skip-visible"
}
dzen2_opts+=(-e "button4=$(scrollcmd -1);button5=$(scrollcmd +1)")
dzen2_opts+=(-ta l)
dzen2_opts+=(-bg "$defaultbg")
dzen2_opts+=(-fg "$defaultfg")

hc pad "$monitor" "$h"
event_init
while true
do
	panel_update
	event_consumer
done < <(event_generator) > >(dzen2 "${dzen2_opts[@]}")
# vim: foldmarker={{{,}}} foldmethod=marker
